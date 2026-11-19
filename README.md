# S-RNase / SLF Self-Incompatibility & Gene Conversion Simulation

MATLAB simulation, analysis, and figure-reproduction codebase for modeling collaborative non-self recognition (S-RNase / SLF) self-incompatibility (SI), self-compatibility (SC) transitions, and inter-haplotype gene conversion ($\mu_g$) in flowering plants.

---

## Requirements

* **MATLAB** (R2021a or newer recommended; uses `exportgraphics` and `groupcounts`)
* **Parallel Computing Toolbox** and a **CUDA-capable NVIDIA GPU** (core evolutionary simulations use `gpuArray` and `gpurng`)

First, add the repository folders to your MATLAB path from the repository root:

```matlab
setupPaths;
```

### Quick Replot of All Paper Figures (No GPU Required)

To directly replot all six manuscript figures from the precomputed numerical `.mat` datasets in `paper_figure/data/`:

```matlab
run('paper_figure/replot_all_paper_figures.m');
```

Generated `.fig` and vector `.pdf` files are saved to `paper_figure/output/`.

---

## Repository Structure

```text
├── setupPaths.m                  % Adds simulation/, analysis/, figure_assembly/, and paper_figure/ to path
├── paper_figure/                 % Direct replotting scripts + lightweight numerical source data (no GPU needed)
│   ├── replot_all_paper_figures.m       % Master script replotting all 6 manuscript figures
│   ├── plot_CombinedClassesABCD.m       % Standalone replot script for CombinedClassesABCD
│   ├── plot_ProbabilityCombined.m       % Standalone replot script for ProbabilityCombined
│   ├── plot_EffectiveCombined.m         % Standalone replot script for EffectiveCombined
│   ├── plot_FittnesCombined.m           % Standalone replot script for FittnesCombined
│   ├── plot_SCCombined2.m               % Standalone replot script for SCCombined2
│   ├── plot_DeltaMuCDEF.m               % Standalone replot script for DeltaMuCDEF
│   └── data/                            % Numerical .mat source data for all 6 figures (~88 KB total)
│       ├── CombinedClassesABCD_data.mat
│       ├── ProbabilityCombined_data.mat
│       ├── EffectiveCombined_data.mat
│       ├── FittnesCombined_data.mat
│       ├── SCCombined2_data.mat
│       └── DeltaMuCDEF_data.mat
├── simulation/                   % Step 1: Evolutionary simulations (generates RawResults/*.mat)
│   ├── RepeatBaseFlowerScript.m          % Fixed gene-conversion rate sweep: [0, 0.005, 0.01, 0.02, 0.03, 0.04]
│   ├── RepeatBaseFlowerScriptVaryRate.m  % Evolving gene-conversion rate (Delta mu_g) & neutral control
│   ├── RepeatBaseFlowerScriptMute.m      % Varying point-mutation rates
│   ├── RepeatBaseFlowerScriptInject.m    % Intruding conversion-rate injection experiment
│   ├── RepeatBaseFlowerScriptNumbSLFs.m  % Varying number of SLF paralogs per haplotype
│   ├── BaseFlowerScript.m                % Quick single-run simulation demo
│   ├── SonicBloom.m                      % Main GPU generation loop
│   ├── SampleIntiatorLikeAmit.m          % Haplotype pool & diploid population initializer (fixed mu_g)
│   ├── SampleIntiatorLikeAmitConvSpan.m  % Haplotype pool & diploid population initializer (evolving mu_g)
│   ├── BumbleDatingMadeSimple11.m        % Pollination, SI/SC compatibility, and inbreeding depression
│   ├── MakingBabies7.m                   % Reproduction, Mendelian inheritance, and mu_g mutation ('AddBell')
│   ├── MutationModule5.m                 % Point mutations in RNase and SLF sequences
│   ├── SLFJump7.m                        % Inter-haplotype SLF gene conversion
│   ├── RNaseSLFReactor3.m                % Pairwise RNase-SLF interaction energy & compatibility matrix
│   ├── HaploSCTester.m                   % Haplotype & diploid self-compatibility (SC) evaluator
│   ├── bouquetAnalyzer5.m                % Periodic population snapshot & SI class tracker
│   ├── Divitionator11.m                  % Partitions extant haplotypes into mutually compatible SI classes
│   └── ...                               % Supporting sequence, indexing, and summary helpers
├── analysis/                     % Step 2: Raw data aggregation & single-panel plotting (PaperResults/*.fig)
│   ├── FlowerLoader.m                    % Loads RawResults/*.mat replicates into BaseLoadedFlow struct
│   ├── FlowerLoaderOnlyImpact.m          % Extracts gene-conversion impact & SC transition outcomes
│   ├── GraphMakingAuto.m                 % Batch distribution plotter for a RawResults/<folder> run
│   ├── GraphingAfterManyRunsMakeAllGraphs.m % Plots normalized distributions across all tracked metrics
│   ├── badStruct2Graph.m                 % Aggregates replicates and invokes multiHisto
│   ├── multiHisto.m                      % Normalized multi-curve histogram plotter
│   ├── plotHistSameBins.m                % Shared-bin PDF curve plotter (evolving mu_g panels)
│   ├── linearFitFromFigure.m             % Computes mean ± SD vs. mu_g + linear regression (*_Y panels)
│   ├── meanStdFromCurve.m                % Numerical integration of curve mean and SD
│   ├── fitnessAprox.m                    % Analytical/empirical fitness by class (SI, HSC+, FSC, HSC-)
│   ├── violin.m                          % Kernel-density violin plot utility
│   ├── PlotFitnessViolins.m              % Wrapper generating Fitness_Y_Low.fig and Fitness_Y_High.fig
│   ├── CheckCrossConversionComp.m        % Evaluates neutral vs. SC-creating conversion events
│   ├── MakeGraphEffectConv.m             % Plots Neutral vs. Turn-to-SC conversion frequencies
│   ├── ChangeFigure2Format.m             % Formats single panels to publication dimensions (8.5 x 6.0 cm)
│   ├── formatMatFolderForPaper.m         % Batch-formats saved .mat figures into .fig and vector .pdf
│   ├── PaperSaver.m                      % Exports active figure as PaperResults/<XLabel>.fig & .pdf
│   └── PaperSaverByY.m                   % Exports active figure as PaperResults/<YLabel>_Y.fig & .pdf
└── figure_assembly/              % Step 3: Multi-panel manuscript figure assembly & styling
    ├── ReproduceAllCombinedFigures.m     % Automated script assembling all 6 multi-panel figures
    ├── combineTwoPanels.m                % Parameterized 1x2 figure combiner
    ├── combineFourPanels.m               % Parameterized 2x2 figure combiner
    ├── FigureCombiner.m                  % Interactive 1x2 figure combiner script
    ├── FigureCombiner2.m                 % Alternate 1x2 combiner layout
    ├── Figure4Combiner.m                 % Interactive 2x2 figure combiner script
    ├── convert_fig_letters.m             % Converts panel labels A-F to lowercase a-f
    └── fixAxisLabelsFontAndSave.m        % Standardizes axis fonts/interpreters to Arial and exports PDF
```

---

## Reproducing the Manuscript Figures End-to-End

### Step 1: Generate Raw Simulation Data (`RawResults/`)

1. **Fixed Gene-Conversion Rate Sweep** ($\mu_g \in \{0, 0.005, 0.01, 0.02, 0.03, 0.04\}$, $N = 500$, $3 \times 10^5$ generations, 7 replicates per rate):
   ```matlab
   run('simulation/RepeatBaseFlowerScript.m');
   ```
   Saves replicate `.mat` files in `RawResults/newFolder1/` (`currItter <i> with value <j>.mat`) and initial summary distributions in `Results/newFolder1/`.

2. **Evolving Gene-Conversion Rate ($\Delta \mu_g$) Sweep** (`SLFJumpSpan = [0, 0.1]`, Gaussian step widths `1/10`, `1/30`, `1/60`, `1/90`, `1/120` via `value2Check = [1, 3, 6, 9, 12]`):
   ```matlab
   run('simulation/RepeatBaseFlowerScriptVaryRate.m');
   ```
   * **Neutral $\mu_g$ Control (Panel E of `DeltaMuCDEF`):** Uncomment `miscPara.energyBarrier = gpuArray(10);` in `simulation/RepeatBaseFlowerScriptVaryRate.m` (disabling SI rejection) and re-run.

---

### Step 2: Generate Single-Panel `.fig` Files (`PaperResults/`)

1. **Distribution Panels:**
   Load a raw simulation folder with `GraphMakingAuto('newFolder1')` (or `FlowerLoader` + `badStruct2Graph`), set the publication X/Y axis labels, format with `ChangeFigure2Format(gcf)`, and run `PaperSaver` to export into `PaperResults/`:
   * `Number_of_Classes.fig` (`amountOfDivitions`)
   * `Classified_Population_Proportion.fig` (`howManyDivitioned / 1000`)
   * `Effective_Number_of_Distinct_Haplotypes.fig` (`effectiveNumber`)
   * `Proportion_of_SC_Haplotypes.fig` (`SC / 1000` or `binarySelf`)
   * `Proportion_of_Identical_SLFs.fig` (`identicalSLFProp`)
   * Evolving $\mu_g$ panels (via `plotHistSameBins.m` + `PaperSaver`): `Mutation_of_mu_g.fig`, `Population_Mean_mu_g.fig`, `Neutral_mu_g_of_Haplotypes.fig`, `_mu_g_of_Haplotypes.fig`.

2. **Mean ± SD & Linear Regression Panels (`*_Y.fig`):**
   Open each distribution `.fig` file, call `linearFitFromFigure(gcf)`, and run `PaperSaverByY`:
   * `Number_of_Classes_Y.fig`
   * `Classified_Proportion_Y.fig`
   * `Effective_Number_Y.fig`
   * `Proportion_of_Identical_SLFs_Y.fig`
   * (For `ProportionByRateSC.fig`, X-values use the effective SC creation rate through gene conversion.)

3. **Neutral vs. Turn-to-SC Conversion Frequency (`Probability_Y2.fig`):**
   Load conversion jump records via `FlowerLoaderOnlyImpact.m` and plot neutral (`impactOfJump == 1`) vs. SC-generating (`postSelfJump == 1` given `prevSelfJump == 0`) frequencies across $\mu_g \in \{0.01, 0.02, 0.03, 0.04\}$ using `MakeGraphEffectConv.m` / `CheckCrossConversionComp.m`.

4. **Fitness Violin Panels (`Fitness_Y_Low.fig`, `Fitness_Y_High.fig`):**
   ```matlab
   PlotFitnessViolins('RawResults/newFolder1/currItter 1 with value 2.mat', 'PaperResults/Fitness_Y_Low.fig');
   PlotFitnessViolins('RawResults/newFolder1/currItter 1 with value 6.mat', 'PaperResults/Fitness_Y_High.fig');
   ```

---

### Step 3: Assemble Multi-Panel Manuscript Figures (`CombinedFigures/`)

Once the single-panel `.fig` files are in `PaperResults/`, assemble all six combined figures (including lowercase `a`–`f` / Arial post-processed versions) with a single call:

```matlab
ReproduceAllCombinedFigures('PaperResults', 'CombinedFigures');
```

---

## Figure-to-Code Mapping

| Manuscript Figure | Raw Simulation Script (`simulation/`) | Single-Panel Analysis Scripts (`analysis/`) | Input Sub-Figures (`PaperResults/`) | Multi-Panel Combiner (`figure_assembly/`) |
| :--- | :--- | :--- | :--- | :--- |
| **`CombinedClassesABCD`** | `RepeatBaseFlowerScript.m` | `FlowerLoader.m`, `badStruct2Graph.m`, `multiHisto.m`, `linearFitFromFigure.m` | **A:** `Number_of_Classes.fig`<br>**B:** `Number_of_Classes_Y.fig`<br>**C:** `Classified_Population_Proportion.fig`<br>**D:** `Classified_Proportion_Y.fig` | `Figure4Combiner.m` / `combineFourPanels.m` |
| **`ProbabilityCombined`** | `RepeatBaseFlowerScript.m` | `FlowerLoaderOnlyImpact.m`, `MakeGraphEffectConv.m`, `CheckCrossConversionComp.m`, `linearFitFromFigure.m` | **A:** `Probability_Y2.fig`<br>**B:** `Proportion_of_Identical_SLFs_Y.fig` | `FigureCombiner.m` / `combineTwoPanels.m` |
| **`EffectiveCombined`** | `RepeatBaseFlowerScript.m` | `FlowerLoader.m`, `badStruct2Graph.m`, `multiHisto.m`, `linearFitFromFigure.m` | **A:** `Effective_Number_of_Distinct_Haplotypes.fig`<br>**B:** `Effective_Number_Y.fig` | `FigureCombiner.m` / `combineTwoPanels.m` |
| **`FittnesCombined`** | `RepeatBaseFlowerScript.m` | `fitnessAprox.m`, `violin.m`, `PlotFitnessViolins.m` | **A:** `Fitness_Y_Low.fig`<br>**B:** `Fitness_Y_High.fig` | `FigureCombiner.m` / `combineTwoPanels.m` |
| **`SCCombined2`** | `RepeatBaseFlowerScript.m` | `FlowerLoader.m`, `badStruct2Graph.m`, `multiHisto.m`, `linearFitFromFigure.m` | **A:** `Proportion_of_SC_Haplotypes.fig`<br>**B:** `ProportionByRateSC.fig` | `FigureCombiner.m` / `combineTwoPanels.m` |
| **`DeltaMuCDEF`** | `RepeatBaseFlowerScriptVaryRate.m`, `MakingBabies7.m` | `FlowerLoader.m`, `plotHistSameBins.m`, `badStruct2Graph.m` | **C:** `Mutation_of_mu_g.fig`<br>**D:** `Population_Mean_mu_g.fig`<br>**E:** `Neutral_mu_g_of_Haplotypes.fig`<br>**F:** `_mu_g_of_Haplotypes.fig` | `Figure4Combiner.m` / `combineFourPanels.m` |

