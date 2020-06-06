def createMatrecTrans(polineMbo):
    polinetype = polineMbo.getString('LINETYPE')
    if polinetype == 'Item':
        matrecSet = poline.getMboSet('MATRECTRANS')
    else:
        matrecSet = poline.getMboSet('SERVRECTRANS')
    matrec = matrecSet.add()
    matrec.setValue('ACTUALCOST','')
    matrec.setValue('ACTUALDATE','')
    matrec.setValue('CURBAL','')
    matrec.setValue('CURRENCYCODE','')
    matrec.setValue('ENTERBY','MAXADMIN')
    matrec.setValue('FROMSITEID','')
    matrec.setValue('LANGCODE','EN')
    matrec.setValue('LINECOST',polineMbo.getString('LINECOST'))
    matrec.setValue('LINETYPE',polineMbo.getString('LINETYPE'))
    matrec.setValue('LOADEDCOST',polineMbo.getString('LOADEDCOST'))
    matrec.setValue('ORGID',polineMbo.getString('ORGID'))
    matrec.setValue('REJECTQTY','')
    matrec.setValue('SITEID',polineMbo.getString('SITEID'))
    matrec.setValue('TRANSDATE','')
    matrec.setValue('UNITCOST',polineMbo.getString('UNITCOST'))
    matrecSet.save()
    return True



polineset = mbo.getMboSet('POLINE')
receipt = mbo.getString('RECEIPTS')
polinesetCount = polineset.getSize()
if polinesetCount and receipt == 'NONE' and mbo.getString('STATUS') == 'APPR':
    for i in range(polinesetCount):
    polineMbo = polineset.getMbo(i)
    receiptGenerated = createMatrecTrans(polineMbo)
    if receiptGenerated:
        polineMbo.setValue('RECEIPTSCOMPLETE', True)
        mbo.setValue('PRETAXTOTAL',)
        allReceiptComp = i + 1
if allReceiptComp == polinesetCount:
    mbo.setValue('RECEIPTS', 'COMPLETE')
