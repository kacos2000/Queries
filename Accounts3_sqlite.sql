Select 
datetime('2001-01-01', zaccount.zdate || ' seconds') as 'AccDate',
ZACCOUNTTYPE.ZACCOUNTTYPEDESCRIPTION as 'AccTypeDescription',
ZACCOUNTTYPE.ZIDENTIFIER as 'AccountIdentifier',
zaccount.ZUSERNAME as 'Username',
zaccount.ZACCOUNTDESCRIPTION as 'Description',
case zaccount.ZACTIVE 
	when 0 then 'No'
	when 1 then 'Yes' 
	end as 'Active',
case zaccount.ZAUTHENTICATED 
	when 0 then 'No'
	when 1 then 'Yes' 
	end as 'Authenticated',
case zaccount.ZSUPPORTSAUTHENTICATION 
	when 0 then 'No'
	when 1 then 'Yes' 
	end as 'SupportsAuth',	
zaccount.ZAUTHENTICATIONTYPE as 'AuthenticationType',
ZACCOUNTTYPE.ZCREDENTIALTYPE as 'CredentialType',
case zaccount.ZVISIBLE 
	when 0 then 'No'
	when 1 then 'Yes' 
	end as 'Visible',
zaccount.ZIDENTIFIER as 'Identifier',
zaccount.ZOWNINGBUNDLEID as 'OwningBundleID'


from zaccount
join ZACCOUNTTYPE on ZACCOUNTTYPE.Z_PK = zaccount.'ZACCOUNTTYPE'

order by AccDate desc