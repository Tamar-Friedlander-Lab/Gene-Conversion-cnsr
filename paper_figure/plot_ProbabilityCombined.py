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


def plot_errorbars(ax, x_data, y_data, y_sd, x_width):
    eheight_l = y_data - y_sd
    eheight_h = y_data + y_sd
    for x_val, y_low, y_high in zip(x_data, eheight_l, eheight_h):
        ax.plot([x_val, x_val], [y_low, y_high], color='black', linewidth=LW * 1.5)
        ax.plot([x_val - x_width, x_val + x_width], [y_low, y_low], color='black', linewidth=LW * 1.5)
        ax.plot([x_val - x_width, x_val + x_width], [y_high, y_high], color='black', linewidth=LW * 1.5)


def plot_ProbabilityCombined(save_output=True):
    here = os.path.dirname(os.path.abspath(__file__))
    data = scipy.io.loadmat(os.path.join(here, 'data', 'ProbabilityCombined_data.mat'))
    leg_labels = [str(x.squeeze()) for x in data['panel_a_labels'].flatten()]

    apply_fig3_rcparams()
    fig, axes = plt.subplots(1, 2, figsize=(6.0, 2.25))
    plt.subplots_adjust(wspace=0.32, hspace=0.1)

    # --- Panel a: Neutral vs. Turn-to-SC gene conversion frequency ---
    ax = axes[0]
    ax.spines['right'].set_visible(False)
    ax.spines['top'].set_visible(False)

    x_a = data['panel_a_x'].ravel()
    y_neutral = data['panel_a_y_neutral'].ravel()
    y_turn_sc = data['panel_a_y_turn_to_sc'].ravel()

    ax.plot(x_a, y_neutral, '--o', ms=4.5, linewidth=LW, alpha=1.0, label=leg_labels[0])
    ax.plot(x_a, y_turn_sc, '--o', ms=4.5, linewidth=LW, alpha=1.0, label=leg_labels[1])

    ax.set_xlim([0.0085, 0.0415])
    ax.set_ylim([0.2, 0.7])
    ax.set_xticks(np.linspace(0.01, 0.04, 7), minor=True)
    ax.set_xticks([0.01, 0.02, 0.03, 0.04], minor=False)
    ax.set_yticks(np.linspace(0.2, 0.7, 11), minor=True)
    ax.set_yticks([0.2, 0.3, 0.4, 0.5, 0.6, 0.7], minor=False)
    ax.tick_params(axis='both', which='major', labelsize=TSIZE)
    ax.tick_params(axis='both', which='minor', labelsize=TSIZE)

    ax.set_title('a', fontweight='bold', loc='left')
    ax.set_xlabel('Gene conversion rate', fontsize=LSIZE)
    ax.set_ylabel('Frequency', fontsize=LSIZE)
    ax.legend(framealpha=0, loc='center right', fontsize=LGSIZE)

    # --- Panel b: Proportion of identical SLFs vs GC rate ---
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
    ax.set_ylim([-0.05, 0.20])
    ax.set_xticks(np.linspace(0, 0.04, 9), minor=True)
    ax.set_xticks([0, 0.01, 0.02, 0.03, 0.04], minor=False)
    ax.set_yticks(np.linspace(-0.05, 0.20, 11), minor=True)
    ax.set_yticks([-0.05, 0.00, 0.05, 0.10, 0.15, 0.20], minor=False)
    ax.tick_params(axis='both', which='major', labelsize=TSIZE)
    ax.tick_params(axis='both', which='minor', labelsize=TSIZE)

    ax.set_title('b', fontweight='bold', loc='left')
    ax.set_xlabel('Gene conversion rate', fontsize=LSIZE)
    ax.set_ylabel('Proportion of identical SLFs', fontsize=LSIZE)

    if save_output:
        out_dir = os.path.join(here, 'output')
        os.makedirs(out_dir, exist_ok=True)
        plt.savefig(os.path.join(out_dir, 'Fig9_new.pdf'), bbox_inches='tight', pad_inches=0.01)
    plt.close(fig)


if __name__ == '__main__':
    plot_ProbabilityCombined(True)

