
# Instructions for ensuring directory and file permissions are set
# correctly for the CaVEMan practical


# unpack reference data and update permissions to ensure it is
# accessible from within docker container

cd /PATH_TO/reference_data

tar zxf core_ref_GRCh37d5.tar.gz 
tar zxf SNV_INDEL_ref_GRCh37d5.tar.gz 

find . -type f | xargs chmod ugo+r
find . -type d | xargs chmod ugo+rx


# update permissions for BAM file directory and BAM files themselves

cd /PATH_TO/data
chmod ugo+rx .
chmod ugo+r *.ba[ims]


# update permissions for the working directory for the practical

cd /PATH_TO/caveman_practical
chmod ugo+rwx .

