# PIMA: High-Throughput Analysis of Protein Interfaces

**PIMA-Wrapper** is a professional-grade Python suite designed for the large-scale structural analysis of macromolecular assemblies. It serves as a high-performance local implementation of the **PIMA** (Protein-Protein Interaction in Macromolecular Assembly) and **PPCheck** methodologies developed at **Prof. R. Sowdhamini’s Lab, NCBS**.

This wrapper automates the extraction, energetic profiling, and hotspot prediction of protein-protein interfaces, with native support for large-scale assemblies (mmCIF) and multi-threaded execution.

## 🔬 Core Capabilities
* **Energetic Profiling:** Quantifies interface strength using pseudo-energies (van der Waals, Hydrogen bonds, and Electrostatics) via the **PPCheck** algorithm.
* **Hotspot Prediction:** Identifies critical residue contributors to binding affinity using the **HotPIES** framework.
* **Geometric Analysis:** Integrated Solvent Accessible Surface Area (SASA) calculations using **FreeSASA**.
* **Large-Assembly Support:** Optimized for "huge" complexes (e.g., gap junctions, viral capsids) by handling mmCIF formats and complex chain-pair combinations.
* **Scalable Architecture:** Utilizes Python’s `ProcessPoolExecutor` for parallel processing across structural datasets.

## 🛠 Installation & Setup

### Prerequisites
* **Python 3.10+**
* **Biopython** (`pip install biopython`)
* **External Binaries:** This wrapper requires local installations of `PPCheck`, `HotPIES`, and `FreeSASA`.
* **System Tools:** `tcsh` (for Naccess dependencies) and `Java JRE` (for Weka-based hotspot analysis).

### Configuration
Update the `default.conf` file with the absolute paths to your local tool binaries:
```ini
ppcheck_codes_folder=/path/to/ppcheck
hotpies_codes_folder=/path/to/hotpies
freesasa_path=/path/to/freesasa

## External Dependencies
This pipeline integrates several high-quality external tools. Please ensure you credit the original authors if you use the SASA or visualization features:

* **FreeSASA:** Mitternacht S. FreeSASA: An open source C library for solvent accessible surface area calculations. *F1000Research*. 2016;5:189.
* **Biopython:** Cock PJ, et al. Biopython: freely available Python tools for computational molecular biology and bioinformatics. *Bioinformatics*. 2009;25(11):1422-3.
* **Naccess:** Hubbard, S. J., & Thornton, J. M. (1993). Department of Biochemistry and Molecular Biology, University College London.


