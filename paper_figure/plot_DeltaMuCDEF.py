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


def plot_DeltaMuCDEF(save_output=True):
    here = os.path.dirname(os.path.abspath(__file__))
    data = scipy.io.loadmat(os.path.join(here, 'data', 'DeltaMuCDEF_data.mat'))
    leg_labels = [str(x.squeeze()) for x in data['step_width_labels'].flatten()]

    apply_fig3_rcparams()
    fig, axes = plt.subplots(2, 2, figsize=(6.0, 4.7))
    plt.subplots_adjust(wspace=0.3, hspace=0.45)

    # --- Panel a: Mutation step distribution Delta mu_g PDF ---
    ax = axes[0, 0]
    ax.spines['right'].set_visible(False)
    ax.spines['top'].set_visible(False)

    x_c = data['panel_c_x']
    y_c, ylabel_a, exp_a = compute_pdf_and_scale(x_c, data['panel_c_y'])
    scale_a = 10 ** exp_a
    for k, label in enumerate(leg_labels):
        ax.plot(x_c[:, k], y_c[:, k], '-', linewidth=LW, alpha=1.0, label=label)

    ax.set_xlim([-0.1, 0.1])
    ax.set_ylim([0, 50 * scale_a])
    ax.set_xticks(np.linspace(-0.1, 0.1, 9), minor=True)
    ax.set_xticks([-0.1, -0.05, 0, 0.05, 0.1], minor=False)
    ax.set_yticks(np.arange(0, 51, 5) * scale_a, minor=True)
    ax.set_yticks(np.array([0, 10, 20, 30, 40, 50]) * scale_a, minor=False)
    ax.tick_params(axis='both', which='major', labelsize=TSIZE)
    ax.tick_params(axis='both', which='minor', labelsize=TSIZE)

    ax.set_title('a', fontweight='bold', loc='left')
    ax.set_xlabel(r'$\Delta \mu_g$', fontsize=LSIZE)
    ax.set_ylabel(ylabel_a, fontsize=LSIZE)
    ax.legend(framealpha=0, loc='upper right', fontsize=LGSIZE)

    # --- Panel b: Population mean mu_g PDF ---
    ax = axes[0, 1]
    ax.spines['right'].set_visible(False)
    ax.spines['top'].set_visible(False)

    x_d = data['panel_d_x']
    y_d, ylabel_b, exp_b = compute_pdf_and_scale(x_d, data['panel_d_y'])
    scale_b = 10 ** exp_b
    for k, label in enumerate(leg_labels):
        ax.plot(x_d[:, k], y_d[:, k], '-', linewidth=LW, alpha=1.0, label=label)

    ax.set_xlim([0.0013, 0.043])
    ax.set_ylim([0, 110 * scale_b])
    ax.set_xticks(np.linspace(0.005, 0.04, 8), minor=True)
    ax.set_xticks([0.01, 0.02, 0.03, 0.04], minor=False)
    ax.set_yticks(np.arange(0, 111, 10) * scale_b, minor=True)
    ax.set_yticks(np.array([0, 20, 40, 60, 80, 100]) * scale_b, minor=False)
    ax.tick_params(axis='both', which='major', labelsize=TSIZE)
    ax.tick_params(axis='both', which='minor', labelsize=TSIZE)

    ax.set_title('b', fontweight='bold', loc='left')
    ax.set_xlabel(r'Population mean $\mu_g$', fontsize=LSIZE)
    ax.set_ylabel(ylabel_b, fontsize=LSIZE)
    ax.legend(framealpha=0, loc='upper right', fontsize=LGSIZE)

    # --- Panel c: Within-population mu_g PDF (neutral control) ---
    ax = axes[1, 0]
    ax.spines['right'].set_visible(False)
    ax.spines['top'].set_visible(False)

    x_e = data['panel_e_x']
    y_e, ylabel_c, exp_c = compute_pdf_and_scale(x_e, data['panel_e_y'])
    scale_c = 10 ** exp_c
    for k, label in enumerate(leg_labels):
        ax.plot(x_e[:, k], y_e[:, k], '-', linewidth=LW, alpha=1.0, label=label)

    ax.set_xlim([0.0058, 0.0949])
    ax.set_ylim([0, 62 * scale_c])
    ax.set_xticks(np.linspace(0.01, 0.09, 9), minor=True)
    ax.set_xticks([0.02, 0.04, 0.06, 0.08], minor=False)
    ax.set_yticks(np.arange(0, 61, 10) * scale_c, minor=True)
    ax.set_yticks(np.array([0, 20, 40, 60]) * scale_c, minor=False)
    ax.tick_params(axis='both', which='major', labelsize=TSIZE)
    ax.tick_params(axis='both', which='minor', labelsize=TSIZE)

    ax.set_title('c', fontweight='bold', loc='left')
    ax.set_xlabel(r'Within population $\mu_g$, neutral', fontsize=LSIZE)
    ax.set_ylabel(ylabel_c, fontsize=LSIZE)
    ax.legend(framealpha=0, loc='upper right', fontsize=LGSIZE)

    # --- Panel d: Within-population mu_g PDF (under SI selection) ---
    ax = axes[1, 1]
    ax.spines['right'].set_visible(False)
    ax.spines['top'].set_visible(False)

    x_f = data['panel_f_x']
    y_f, ylabel_d, exp_d = compute_pdf_and_scale(x_f, data['panel_f_y'])
    scale_d = 10 ** exp_d
    for k, label in enumerate(leg_labels):
        ax.plot(x_f[:, k], y_f[:, k], '-', linewidth=LW, alpha=1.0, label=label)

    ax.set_xlim([0.0002, 0.0800])
    ax.set_ylim([0, 62 * scale_d])
    ax.set_xticks(np.linspace(0.01, 0.08, 8), minor=True)
    ax.set_xticks([0.02, 0.04, 0.06], minor=False)
    ax.set_yticks(np.arange(0, 61, 10) * scale_d, minor=True)
    ax.set_yticks(np.array([0, 20, 40, 60]) * scale_d, minor=False)
    ax.tick_params(axis='both', which='major', labelsize=TSIZE)
    ax.tick_params(axis='both', which='minor', labelsize=TSIZE)

    ax.set_title('d', fontweight='bold', loc='left')
    ax.set_xlabel(r'Within population $\mu_g$', fontsize=LSIZE)
    ax.set_ylabel(ylabel_d, fontsize=LSIZE)
    ax.legend(framealpha=0, loc='upper right', fontsize=LGSIZE)

    if save_output:
        out_dir = os.path.join(here, 'output')
        os.makedirs(out_dir, exist_ok=True)
        plt.savefig(os.path.join(out_dir, 'Fig8_new.pdf'), bbox_inches='tight', pad_inches=0.01)
    plt.close(fig)


if __name__ == '__main__':
    plot_DeltaMuCDEF(True)
