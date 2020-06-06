def beforeCreateMboSet(ctx): 
   struc = ctx.getData()
   siteid = struc.getCurrentData("SITEID")
   if siteid is None or siteid =="":
       struc.setCurrentData("SITEID", "BEDFORD") 
       struc.setCurrentData("ORGID", "EAGLENA")
       struc.setCurrentData("XXORGID", "EAGLENA") #Custom orgid id field