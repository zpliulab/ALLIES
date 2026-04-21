# [CellLand for Cell dynamics on energy Landscapes](https://github.com/zpliulab/CellLand)

**CellLand** benchmarks **principal component-based energy landscape mapping** on EMT-MET, Melanoma, and SERGIO-simulated datasets with prior regulatory network knowledge. 

![Screenshot](Figure/Framwork_Github.png)


---

## CellLand

<!--START_SECTION:news-->

* **CellLand** (**Cell** dynamics on energy **Land**scapes) is a comprehensive pipeline for benchmarking attractor detection in **Boolean** and **diffusion-based** models under *in silico* driver-gene perturbation.
* **Data** contains all input and output files. Because some files exceed 100 MB, they cannot be uploaded to this repository. All data analyzed in this work are available on [figshare](https://figshare.com/articles/dataset/CellLand_supplementary_data/32055507).
* **Boolean network tutorial (Python):** [PCA_visualization.ipynb](https://github.com/zpliulab/ALLIES/blob/main/Code/PCA_visualization.ipynb) provides fully reproducible workflow.
* **Diffusion model tutorial (MATLAB):** [plot_Landscape.m](https://github.com/zpliulab/ALLIES/blob/main/Code/diffusion/Melanoma_Landscape/code/plot_Landscape.m), run with `matlab -r "plot_Landscape"`.
* Questions about **CellLand** could be directed to the corresponding author, [Prof. Zhi-Ping Liu](https://scholar.google.com/citations?user=zkBXb_kAAAAJ&hl=zh-CN&oi=ao) (email: zpliu@sdu.edu.cn).

<!--END_SECTION:news-->


---
## Boolean model

### Conda environment

Use Python 3.10 or 3.11.

```bash
conda create -n CellLand python=3.11 -y
conda activate CellLand
conda install -c conda-forge numpy pandas scipy matplotlib scikit-learn seaborn
```

---

It allows users load **`Code/bmodel/`** via `sys.path` without installing. 

```python
import sys
from pathlib import Path

for p in (Path("Code/bmodel"), Path("bmodel")):
    if (p / "bmodel" / "base.py").is_file():
        sys.path.insert(0, str(p.resolve()))
        break

from bmodel.base import Bmodel
```

Upstream package: [ComplexityBiosystems/bmodel](https://github.com/ComplexityBiosystems/bmodel).


---
## Diffusion model

### MATLAB workflow

Launch MATLAB and run the diffusion-model landscape example from:

```bash
cd ALLIES/Code/diffusion/Melanoma_Landscape/code/
matlab -r "plot_Landscape"
```

Or start MATLAB interactively and execute:

```matlab
plot_Landscape
```

Upstream package: [chunhelilab/Melanoma_Landscape](https://github.com/chunhelilab/Melanoma_Landscape).



---

## Citation

Lingyu Li, Liangjie Sun, Shumin Li, Wai-Ki Ching*, and Zhi-Ping Liu*. "**Cell dynamics on energy landscapes: Comparing attractor detection in Boolean-network and diffusion-based models under *in silico* driver gene perturbations**." Submitted and revised to [Quantitative Biology](https://onlinelibrary.wiley.com/journal/20954697).

