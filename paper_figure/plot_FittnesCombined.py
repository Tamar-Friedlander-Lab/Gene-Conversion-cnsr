import os
import numpy as np
import scipy.io
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon

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


def draw_violin_panel(ax, verts_3d, med_x, med_y, face_col, class_labels, panel_letter):
    ax.spines['right'].set_visible(False)
    ax.spines['top'].set_visible(False)

    rgba_face = (float(face_col[0]), float(face_col[1]), float(face_col[2]), 0.5)
    for k in range(verts_3d.shape[2]):
        verts = verts_3d[:, :, k]
        poly = Polygon(verts, closed=True, facecolor=rgba_face, edgecolor='black', linewidth=LW)
        ax.add_patch(poly)
        ax.plot(
            med_x[:, k],
            med_y[:, k],
            '-',
            color='red',
            linewidth=LW * 1.5,
            label='Median' if k == 0 else None,
        )

    ax.set_xlim([0.5, 4.5])
    ax.set_ylim([0.4, 1.2])
    ax.set_xticks([1, 2, 3, 4], minor=False)
    ax.set_xticklabels(class_labels)
    ax.set_yticks(np.linspace(0.4, 1.2, 9), minor=True)
    ax.set_yticks([0.4, 0.6, 0.8, 1.0, 1.2], minor=False)
    ax.tick_params(axis='both', which='major', labelsize=TSIZE)
    ax.tick_params(axis='y', which='minor', labelsize=TSIZE)

    ax.set_title(panel_letter, fontweight='bold', loc='left')
    ax.set_ylabel('Fitness', fontsize=LSIZE)
    ax.legend(framealpha=0, loc='upper right', fontsize=LGSIZE)


def plot_FittnesCombined(save_output=True):
    here = os.path.dirname(os.path.abspath(__file__))
    data = scipy.io.loadmat(os.path.join(here, 'data', 'FittnesCombined_data.mat'))
    class_labels = ['SI-(SI)', 'SC-(SI)', 'SC-(SC)', 'SI-(SC)']
    face_col = data['face_color'].ravel()

    apply_fig3_rcparams()
    fig, axes = plt.subplots(1, 2, figsize=(6.0, 2.25))
    plt.subplots_adjust(wspace=0.3, hspace=0.1)

    draw_violin_panel(
        axes[0],
        data['panel_a_violin_vertices'],
        data['panel_a_median_x'],
        data['panel_a_median_y'],
        face_col,
        class_labels,
        'a',
    )
    draw_violin_panel(
        axes[1],
        data['panel_b_violin_vertices'],
        data['panel_b_median_x'],
        data['panel_b_median_y'],
        face_col,
        class_labels,
        'b',
    )

    if save_output:
        out_dir = os.path.join(here, 'output')
        os.makedirs(out_dir, exist_ok=True)
        plt.savefig(os.path.join(out_dir, 'Fig4_new.pdf'), bbox_inches='tight', pad_inches=0.01)
    plt.close(fig)


if __name__ == '__main__':
    plot_FittnesCombined(True)

