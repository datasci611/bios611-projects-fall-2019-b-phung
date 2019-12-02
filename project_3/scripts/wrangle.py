import pandas as pd

zip = pd.read_csv("https://raw.githubusercontent.com/biodatascience/datasci611/gh-pages/data/project2_2019/EE_UDES_191102.tsv", sep='\t',
	usecols=['Client ID', 'EE UID', 'Zip Code (of Last Permanent Address, if known)(1932)'],
	na_values=['**'], header = 0) \
	.sort_values(['Client ID', 'EE UID'])
zip['ZC'] = zip[zip.columns[2]].str.slice(0,5)
zip = zip[zip.ZC.str.contains(r'\d{5}', na=False)]
del zip['Zip Code (of Last Permanent Address, if known)(1932)']
zip.to_csv("../data/zip.csv", index=False, header=True)


year = pd.read_csv("https://raw.githubusercontent.com/biodatascience/datasci611/gh-pages/data/project2_2019/ENTRY_EXIT_191102.tsv", sep='\t',
	usecols=['EE UID', 'Entry Date'])
year['year'] = year[year.columns[1]].str.slice(-4)
del year['Entry Date']
year.to_csv("../data/year.csv", index=False, header=True)


hpi = pd.read_csv("https://raw.githubusercontent.com/datasci611/bios611-projects-fall-2019-b-phung/master/project_3/data/hpi.csv",
	converters={'Five-Digit ZIP Code': lambda x: str(x)},
	skiprows = 6, usecols=['Five-Digit ZIP Code', 'Year', 'HPI'])
hpi.to_csv("../data/hpi_wrangled.csv", index=False, header=True)