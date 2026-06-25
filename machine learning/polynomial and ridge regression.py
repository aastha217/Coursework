import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split, KFold
from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import Ridge

# ==========================================================
# LOAD DATASET
# ==========================================================
# CSV file should contain:
# Hours, Rank

df = pd.read_csv("student_data.csv")

X = df[['Hours']].values
y = df['Rank'].values.reshape(-1, 1)

# ==========================================================
# TRAIN TEST SPLIT
# ==========================================================
X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.2,
    random_state=42
)

# ==========================================================
# ADD BIAS TERM
# ==========================================================
def add_bias(X):
    return np.c_[np.ones((X.shape[0],1)), X]

X_train_b = add_bias(X_train)
X_test_b = add_bias(X_test)

# ==========================================================
# CLOSED FORM SOLUTION
# w = (XᵀX)^(-1) Xᵀy
# ==========================================================
w_closed = np.linalg.inv(
    X_train_b.T @ X_train_b
) @ X_train_b.T @ y_train

print("Closed Form Solution Weights:")
print(w_closed)

# ==========================================================
# PREDICTION USING CLOSED FORM
# ==========================================================
y_pred_closed = X_test_b @ w_closed

# ==========================================================
# GRADIENT DESCENT
# ==========================================================
def gradient_descent(
        X,
        y,
        lr=0.01,
        epochs=1000):

    m, n = X.shape

    w = np.zeros((n,1))

    errors = []

    for epoch in range(epochs):

        y_pred = X @ w

        error = np.mean(
            (y - y_pred)**2
        )

        errors.append(error)

        gradient = (
            -2/m
        ) * X.T @ (y - y_pred)

        w = w - lr * gradient

    return w, errors

w_gd, errors = gradient_descent(
    X_train_b,
    y_train,
    lr=0.01,
    epochs=1000
)

print("\nGradient Descent Weights:")
print(w_gd)

# ==========================================================
# PREDICT RANK
# ==========================================================
hours = float(
    input(
        "\nEnter number of hours studied: "
    )
)

pred_rank = np.array([[1, hours]]) @ w_gd

print(
    "Predicted Rank:",
    pred_rank[0][0]
)

# ==========================================================
# TRAINING ERROR VS ITERATIONS
# ==========================================================
plt.figure(figsize=(8,5))

plt.plot(errors)

plt.xlabel("Iterations")
plt.ylabel("Training Error")

plt.title(
    "Training Error vs Iterations"
)

plt.grid(True)

plt.show()

# ==========================================================
# PART (a)
# 4TH ORDER POLYNOMIAL
# ==========================================================
poly4 = PolynomialFeatures(
    degree=4
)

X_poly4 = poly4.fit_transform(X)

w_poly4 = np.linalg.inv(
    X_poly4.T @ X_poly4
) @ X_poly4.T @ y

print("\n4th Degree Polynomial Coefficients:")
print(w_poly4)

# ==========================================================
# PART (b)
# HIGHER ORDER POLYNOMIALS
# ==========================================================
degrees = [6,8,10,12,14,16]

plt.figure(figsize=(8,6))

for degree in degrees:

    poly = PolynomialFeatures(
        degree=degree
    )

    X_poly = poly.fit_transform(X)

    w = np.linalg.pinv(
        X_poly.T @ X_poly
    ) @ X_poly.T @ y

    prediction = X_poly @ w

    error = (
        y - prediction
    )**2

    plt.plot(
        error,
        label=f"Degree {degree}"
    )

    print(
        f"\nDegree {degree} Coefficients:"
    )

    print(w.flatten())

plt.xlabel("Sample Index")
plt.ylabel("Squared Error")

plt.title(
    "Training Error for Different Polynomial Degrees"
)

plt.legend()

plt.show()

# ==========================================================
# PART (c)
# RIDGE REGRESSION
# L2 REGULARIZATION
# ==========================================================

lambdas = [
    0.001,
    0.01,
    0.1,
    1,
    10,
    100
]

best_lambda = None
best_error = float('inf')

cv = KFold(
    n_splits=5,
    shuffle=True,
    random_state=42
)

for lam in lambdas:

    cv_errors = []

    for train_idx, val_idx in cv.split(X_train):

        Xtr = X_train[train_idx]
        Xval = X_train[val_idx]

        ytr = y_train[train_idx]
        yval = y_train[val_idx]

        model = Ridge(
            alpha=lam
        )

        model.fit(Xtr, ytr)

        pred = model.predict(Xval)

        mse = np.mean(
            (yval - pred)**2
        )

        cv_errors.append(mse)

    avg_error = np.mean(
        cv_errors
    )

    if avg_error < best_error:

        best_error = avg_error
        best_lambda = lam

print(
    "\nBest Regularization Parameter:",
    best_lambda
)

# ==========================================================
# PART (d)
# TRAINING & TESTING PERFORMANCE
# ==========================================================

train_mse = []
test_mse = []

for lam in lambdas:

    model = Ridge(
        alpha=lam
    )

    model.fit(
        X_train,
        y_train
    )

    train_pred = model.predict(
        X_train
    )

    test_pred = model.predict(
        X_test
    )

    train_mse.append(
        np.mean(
            (y_train - train_pred)**2
        )
    )

    test_mse.append(
        np.mean(
            (y_test - test_pred)**2
        )
    )

plt.figure(figsize=(8,5))

plt.plot(
    lambdas,
    train_mse,
    marker='o',
    label="Training Error"
)

plt.plot(
    lambdas,
    test_mse,
    marker='s',
    label="Testing Error"
)

# ==========================================================
# PART (e)
# INDICATE BEST λ
# ==========================================================

plt.axvline(
    x=best_lambda,
    color='red',
    linestyle='--',
    label=f"Best λ = {best_lambda}"
)

plt.xscale('log')

plt.xlabel("Regularization Parameter λ")
plt.ylabel("Mean Squared Error")

plt.title(
    "Training and Testing Performance"
)

plt.legend()

plt.grid(True)

plt.show()