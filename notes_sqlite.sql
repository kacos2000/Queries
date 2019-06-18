Select 
znote.Z_PK,
znote.ZGUID as 'GUID',
zaccount.ZNAME as 'Account',
zstore.ZNAME as 'Name',
zstore.ZEXTERNALIDENTIFIER as' ID',
znote.ZAUTHOR as 'Author',
znote.ZTITLE as 'Title',
znote.ZSUMMARY as 'Summary',
znotebody.ZCONTENT as 'Content', --html
znoteattachment.ZCONTENTID as 'contentID',
znoteattachment.ZFILENAME as 'Filename',
znoteattachment.ZMIMETYPE as 'mimetype',
datetime('2001-01-01', znote.ZCREATIONDATE || ' seconds') as 'creationdate',
datetime('2001-01-01', znote.ZMODIFICATIONDATE || ' seconds') as 'modificationdate'


from znote
join znotebody on znote.ZBODY = ZNOTEBODY.Z_PK
join zstore on znote.ZSTORE = zstore.Z_PK
join zaccount on zstore.ZACCOUNT = ZACCOUNT.Z_PK
left join znoteattachment on znoteattachment."ZNOTE"  = znote.Z_PK
order by creationdate desc