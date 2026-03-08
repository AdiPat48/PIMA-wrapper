Usage :

python3 main.py --pdbs_list test_pdb_ids.txt --max_workers_pima 4 --max_workers_ppcheck 4 --pdb_number_start 0 --pdb_number_end 100 --output_folder ppcheck_results --structure_file_format {}.cif --size_sort True --max_ram_mb 10000 --max_number_of_chains 20

* The above command will process the first 100 PDBs from the list test_pdb_ids.txt in parallel using 4 workers for PIMA and 4 workers for PPCheck. The output will be saved in the ppcheck_results folder. The structure files will be in CIF format and sorted by size. The maximum number of chains to process is 20 and the maximum RAM usage is 10 GB.
* More options can be found in the default.conf file or by running python3 main.py --help
