from plot_CombinedClassesABCD import plot_CombinedClassesABCD
from plot_DeltaMuCDEF import plot_DeltaMuCDEF
from plot_EffectiveCombined import plot_EffectiveCombined
from plot_FittnesCombined import plot_FittnesCombined
from plot_ProbabilityCombined import plot_ProbabilityCombined
from plot_SCCombined2 import plot_SCCombined2


def main():
    plot_CombinedClassesABCD(True)
    plot_DeltaMuCDEF(True)
    plot_EffectiveCombined(True)
    plot_FittnesCombined(True)
    plot_ProbabilityCombined(True)
    plot_SCCombined2(True)
    print('All 6 figures saved to ./output/Fig*_new.pdf')


if __name__ == '__main__':
    main()

