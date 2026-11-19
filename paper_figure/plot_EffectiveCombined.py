import os
import numpy as np
import scipy.io
import matplotlib.pyplot as plt

LSIZE = 9
TSIZE = 7
LGSIZE = 8
LW = 1.25


def apply_fig3_rcparams():
    plt.rcParams['axes.xmargin'] = 0.005
    plt.rcParams['axes.ymargin'] = 0.005
    plt.rcParams['figure.subplot.left'] = 0.005
    plt.rcParams['figure.subplot.right'] = 0.995
    plt.rcParams['figure.subplot.bottom'] = 0.005
    plt.rcParams['figure.subplot.top'] = 0.995


def compute_pdf_and_scale(x, y_2d):
    y_pdf = np.zeros_like(y_2d, dtype=float)
    for k in range(y_2d.shape[1]):
        xk = x[:, k] if x.ndim == 2 and x.shape[1] == y_2d.shape[1] else x.ravel()
        dx = float(np.mean(np.diff(xk)))
        y_pdf[:, k] = y_2d[:, k] / (np.sum(y_2d[:, k]) * dx)
    y_max = float(np.nanmax(y_pdf))
    exp = 0
    while y_max * (10 ** exp) < 0.01 and y_max > 0:
        exp += 1
    y_scaled = y_pdf * (10 ** exp)
    ylabel = rf'PDF ($\times 10^{{{exp}}}$)' if exp > 0 else 'PDF'
    return y_scaled, ylabel, exp


def plot_errorbars(ax, x_data, y_data, y_sd, x_width):
    eheight_l = y_data - y_sd
    eheight_h = y_data + y_sd
    for x_val, y_low, y_high in zip(x_data, eheight_l, eheight_h):
        ax.plot([x_val, x_val], [y_low, y_high], color='black', linewidth=LW * 1.5)
        ax.plot([x_val - x_width, x_val + x_width], [y_low, y_low], color='black', linewidth=LW * 1.5)
        ax.plot([x_val - x_width, x_val + x_width], [y_high, y_high], color='black', linewidth=LW * 1.5)


def plot_EffectiveCombined(save_output=True):
    here = os.path.dirname(os.path.abspath(__file__))
    data = scipy.io.loadmat(os.path.join(here, 'data', 'EffectiveCombined_data.mat'))
    leg_labels = [str(x.squeeze()) for x in data['gc_rates_labels'].flatten()]

    apply_fig3_rcparams()
    fig, axes = plt.subplots(1, 2, figsize=(6.0, 2.25))
    plt.subplots_adjust(wspace=0.3, hspace=0.1)

    # --- Panel a: Effective number of distinct S-haplotypes PDF ---
    ax = axes[0]
    ax.spines['right'].set_visible(False)
    ax.spines['top'].set_visible(False)

    x_a = data['panel_a_x'].ravel()
    y_a, ylabel_a, exp_a = compute_pdf_and_scale(x_a, data['panel_a_y'])
    scale_a = 10 ** exp_a
    for k, label in enumerate(leg_labels):
        ax.plot(x_a, y_a[:, k], '-', linewidth=LW, alpha=1.0, label=label)

    ax.set_xlim([14.5, 125])
    ax.set_ylim([0, 0.11 * scale_a])
    ax.set_xticks(np.arange(20, 121, 10), minor=True)
    ax.set_xticks([20, 40, 60, 80, 100, 120], minor=False)
    ax.set_yticks(np.linspace(0, 0.11, 12) * scale_a, minor=True)
    ax.set_yticks(np.array([0, 0.02, 0.04, 0.06, 0.08, 0.10]) * scale_a, minor=False)
    ax.tick_params(axis='both', which='major', labelsize=TSIZE)
    ax.tick_params(axis='both', which='minor', labelsize=TSIZE)

    ax.set_title('a', fontweight='bold', loc='left')
    ax.set_xlabel('Effective number of distinct S-haplotypes', fontsize=LSIZE)
    ax.set_ylabel(ylabel_a, fontsize=LSIZE)
    ax.legend(framealpha=0, loc='upper right', fontsize=LGSIZE)

    # --- Panel b: Mean +/- SD S-haplotype number vs GC rate ---
    ax = axes[1]
    ax.spines['right'].set_visible(False)
    ax.spines['top'].set_visible(False)

    x_b = data['panel_b_x'].ravel()
    y_b = data['panel_b_mean'].ravel()
    sd_b = data['panel_b_sd'].ravel()
    x_fit = data['panel_b_fit_x'].ravel()
    y_fit = data['panel_b_fit_y'].ravel()

    ax.plot(x_b, y_b, 'o', ms=5.0, color='black', alpha=1.0)
    ax.plot(x_fit, y_fit, '--', color='black', linewidth=LW)
    plot_errorbars(ax, x_b, y_b, sd_b, x_width=0.001)

    ax.set_xlim([-0.002, 0.042])
    ax.set_ylim([20, 80])
    ax.set_xticks(np.linspace(0, 0.04, 9), minor=True)
    ax.set_xticks([0, 0.01, 0.02, 0.03, 0.04], minor=False)
    ax.set_yticks(np.arange(20, 81, 10), minor=True)
    ax.set_yticks([20, 40, 60, 80], minor=False)
    ax.tick_params(axis='both', which='major', labelsize=TSIZE)
    ax.tick_params(axis='both', which='minor', labelsize=TSIZE)

    ax.set_title('b', fontweight='bold', loc='left')
    ax.set_xlabel('Gene conversion rate', fontsize=LSIZE)
    ax.set_ylabel('S-haplotype number', fontsize=LSIZE)

    if save_output:
        out_dir = os.path.join(here, 'output')
        os.makedirs(out_dir, exist_ok=True)
        plt.savefig(os.path.join(out_dir, 'Fig5_new.pdf'), bbox_inches='tight', pad_inches=0.01)
    plt.close(fig)


if __name__ == '__main__':
    plot_EffectiveCombined(True)
