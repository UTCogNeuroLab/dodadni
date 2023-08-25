#!/usr/bin/env python3
# Plot tract profile plots using tracula data
# Makenna McGill
# adapted from Brad Caron

# load modules
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

# load dataframe
df = pd.read_csv('/Volumes/schnyer/Makenna/DODADNI/Data_Analysis/tractprofile_max_labelrecode.csv')

# compute average tract profile for specific tract
cc_bodypm = df.loc[df['structureID'] == 'cc.bodypm']
sns.lineplot(x='nodeID',y='FA',data=cc_bodypm)
plt.show()

# compute average tract profiles within each tbi group for specific tract
rh_cst = df.loc[df['structureID'] == 'rh.cst']
ax = sns.lineplot(x='nodeID',y='FA',hue='tbi_group',palette='muted', data=rh_cst)
# smooth lines, in which increasing the window parameter increases the smoothing
for line in ax.lines:
    y = line.get_ydata()
    y_smooth = pd.Series(y).rolling(window=3, min_periods=1, center=True).mean()
    line.set_ydata(y_smooth)
# add labels
ax.set(xlabel='Right Corticospinal Tract', ylabel='FA')
plt.legend(title='TBI Group')
# create significance window using [x1, x1, x2, x2], [y1, y2, y2, y1], where node range is x1 to x2 and y values control vertical placement
plt.plot([66, 66, 71, 71], [.35, .34, .34, .35], linewidth=1.25, color='k')
plt.show()

# compute average tract profiles within each vascular burden group for specific tract
cc_bodyc = df.loc[df['structureID'] == 'cc.bodyc']
ax = sns.lineplot(x='nodeID',y='FA',hue='vas_burden',palette='muted', data=cc_bodyc)
# smooth lines, in which increasing the window parameter increases the smoothing
for line in ax.lines:
    y = line.get_ydata()
    y_smooth = pd.Series(y).rolling(window=3, min_periods=1, center=True).mean()
    line.set_ydata(y_smooth)
# add labels
ax.set(xlabel='Central Body of Corpus Callosum', ylabel='FA')
plt.legend(title='Vascular Burden Score')
# create significance window using [x1, x1, x2, x2], [y1, y2, y2, y1], where node range is x1 to x2 and y values control vertical placement
plt.plot([37, 37, 44, 44], [.46, .45, .45, .46], linewidth=1.25, color='k')
plt.show()
