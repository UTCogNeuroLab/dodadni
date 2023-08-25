#!/usr/bin/env python3
# Concatenate tracula along-tract data for visualization
# Makenna McGill
# adapted from Brad Caron

# python3 /Volumes/schnyer/Makenna/DODADNI/Scripts/concatenate_tracula_profile_data_max.py -fp /Volumes/schnyer/Makenna/DODADNI/BIDS/derivatives/tracula/stats/tract_profile_max -of '/Volumes/schnyer/Makenna/DODADNI/Data_Analysis/tractprofile_max.csv'

import argparse
import numpy as np
import pandas as pd
import glob

# function to identify the measures from the filepaths
def identify_measures(filepaths):

	return [ j.split('.txt')[0].split('.')[-1] for j in filepaths ]

# function to build dataframe across all tracts and measures to make plot making much easier
def build_dataframe(filepaths,measures,output_file,path_to_files):

	# df = pd.DataFrame(columns={'subjectID','structureID','nodeID'}) # build the final dataframe with specific columns
	df = pd.DataFrame() # build the final dataframe with specific columns

	# loop through all unique measures found in filelist
	for i in np.unique(measures):
		tmp_out = pd.DataFrame() # build temporary dataframe for each measure

		fpaths = [ f for f in filepaths if i in f ] # identify all files with that measure

		# loop through files, load data, build dataframe
		for j in fpaths:

			# identify the structure name. remove any '/' characters
			structure = '.'.join(j.split(path_to_files)[1].split('.txt')[0].split('.')[0:2])
			if '/' in structure:
				structure = structure.split('/')[1]

			# load the data and melt to transform from wide to long
			tmp = pd.read_table(j,sep='\s') # loads the text file as a wide table with each column a subject's profile
			tmp = pd.melt(tmp,col_level=0) # this will convert the frame from wide to long

			# rename columns so they make sense
			tmp = tmp.rename(columns={'variable': 'subjectID', 'value': i}) # rename the column names to something more user readible

			# add a column for the structure name
			tmp['structureID'] = [ structure for f in range(len(tmp['subjectID'])) ] # list comprehension to add a new column called 'structureID' where each value is the structure name

			# identify the number of locations (nodes) used to generate the profile. add a column indicator to dataframe (needed for plots)
			node_length = len(tmp.loc[tmp['subjectID'] == tmp.subjectID.unique().tolist()[0] ])
			nodes = []
			for sub in tmp.subjectID.unique().tolist():
				nodes = nodes + list(range(node_length))
			tmp['nodeID'] = nodes

			# concatenate dataframes for all tract data within a given measure
			tmp_out = pd.concat([tmp_out,tmp])

		# merge dataframes across measures. if we are at the first measure, just set df as the tmp dataframe. if not, merge on subjectID, structureID, and nodeID
		if i == measures[0]:
			df = tmp_out
		else:
			df = pd.merge(df,tmp_out,on=['subjectID','structureID','nodeID'])

		# reorder columns
		df = df.reindex(columns=['subjectID','structureID','nodeID'] + [ f for f in df.keys().tolist() if f not in ['subjectID','structureID','nodeID'] ])

	# drop duplicates and reset index
	df = df.drop_duplicates(['subjectID','structureID','nodeID']).reset_index(drop=True)

	# merge dataframe with df that contains important covariates (tbi group, ptsd, vascular burden, & age)
	df_groups = pd.read_csv('/Volumes/schnyer/Makenna/DODADNI/Data_Analysis/traculagroups.csv') #load separate df that contains tbi grouping and covariates
	df = pd.merge(df, df_groups, on='subjectID')

	# output file to csv
	df.to_csv(output_file,index=False)

	return df

# main function to identify filepaths, measures, and to build the final dataframe
def main(path_to_files, output_file):

	filepaths = glob.glob(path_to_files+'/*.txt')

	measures = list(np.unique(identify_measures(filepaths)))

	# remove average data
	measures = [ f for f in measures if '_Avg' not in f and 'inputs' not in f ]

	df = build_dataframe(filepaths,measures,output_file,path_to_files)

if __name__ == '__main__':

	parser = argparse.ArgumentParser(description='Build a dataframe for all profile outputs from tracula for visualization profiles')
	parser.add_argument('-fp','--path_to_files', required=True, help="Filepaths for the tracula outputs")
	parser.add_argument('-of','--output_file', required=True, help="Filepath for final dataframe")

	args = parser.parse_args()

	main(args.path_to_files,args.output_file)
