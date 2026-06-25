import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm
from sklearn.metrics import auc

# ==========================================================
# BIOMETRIC MATCHER ANALYSIS
# Genuine Distribution  : N(30, 10)
# Impostor Distribution : N(60, 15)
#
# Mean and Variance are given.
# Standard Deviation = sqrt(Variance)
# ==========================================================

# Genuine score distribution
mu_g = 30
var_g = 10
sigma_g = np.sqrt(var_g)

# Impostor score distribution
mu_i = 60
var_i = 15
sigma_i = np.sqrt(var_i)

# ==========================================================
# PLOT GENUINE AND IMPOSTOR DISTRIBUTIONS
# ==========================================================

# Score range
x = np.linspace(0, 100, 1000)

# Probability Density Functions
genuine_pdf = norm.pdf(
    x,
    mu_g,
    sigma_g
)

impostor_pdf = norm.pdf(
    x,
    mu_i,
    sigma_i
)

plt.figure(figsize=(8,5))

plt.plot(
    x,
    genuine_pdf,
    label="Genuine Distribution"
)

plt.plot(
    x,
    impostor_pdf,
    label="Impostor Distribution"
)

plt.xlabel("Matching Score")
plt.ylabel("Probability Density")

plt.title(
    "Genuine and Impostor Score Distributions"
)

plt.legend()
plt.grid(True)

plt.show()

# ==========================================================
# FUNCTION TO COMPUTE FAR AND FRR
# Decision Rule:
#
# Genuine  if score <= threshold
# Impostor if score > threshold
#
# FAR = P(Impostor classified as Genuine)
#     = P(Impostor Score <= Threshold)
#
# FRR = P(Genuine classified as Impostor)
#     = P(Genuine Score > Threshold)
# ==========================================================

def compute_far_frr(threshold):

    # FAR
    far = norm.cdf(
        threshold,
        mu_i,
        sigma_i
    )

    # FRR
    frr = 1 - norm.cdf(
        threshold,
        mu_g,
        sigma_g
    )

    return far, frr

# ==========================================================
# THRESHOLD = 50
# ==========================================================

far_50, frr_50 = compute_far_frr(50)

print("=================================")
print("Threshold η = 50")
print("FAR =", far_50)
print("FRR =", frr_50)
print("=================================")

# ==========================================================
# THRESHOLD = 75
# ==========================================================

far_75, frr_75 = compute_far_frr(75)

print("\n=================================")
print("Threshold η = 75")
print("FAR =", far_75)
print("FRR =", frr_75)
print("=================================")

# ==========================================================
# ROC CURVE
#
# TPR = 1 - FRR
# FPR = FAR
# ==========================================================

thresholds = np.linspace(
    0,
    100,
    1000
)

far_values = []
frr_values = []
tpr_values = []

for t in thresholds:

    far, frr = compute_far_frr(t)

    far_values.append(far)
    frr_values.append(frr)

    tpr_values.append(
        1 - frr
    )

far_values = np.array(
    far_values
)

frr_values = np.array(
    frr_values
)

tpr_values = np.array(
    tpr_values
)

# ==========================================================
# ROC CURVE
# ==========================================================

plt.figure(figsize=(7,6))

plt.plot(
    far_values,
    tpr_values
)

plt.xlabel("False Acceptance Rate (FAR)")
plt.ylabel("True Positive Rate (TPR)")

plt.title("ROC Curve")

plt.grid(True)

plt.show()

# ==========================================================
# AUC COMPUTATION
# ==========================================================

roc_auc = auc(
    far_values,
    tpr_values
)

print(
    "\nArea Under Curve (AUC) =",
    roc_auc
)

# ==========================================================
# DET CURVE
#
# X-Axis : FAR
# Y-Axis : FRR
# ==========================================================

plt.figure(figsize=(7,6))

plt.plot(
    far_values,
    frr_values
)

plt.xlabel(
    "False Acceptance Rate (FAR)"
)

plt.ylabel(
    "False Rejection Rate (FRR)"
)

plt.title("DET Curve")

plt.grid(True)

plt.show()