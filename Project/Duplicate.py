# Script to set ROSLINE when ROS Mbo get duplicated

roslineSet = mbo.getMboSet('ROSLINE')
rosline = roslineSet.moveFirst()
while rosline:
     dupRoslineSet = dupmbo.getMboSet('ROSLINE')
     dupRosline = dupRoslineSet.addAtEnd()
     dupRosline.setValue('PONUM',rosline.getString('PONUM'), 2L)
     dupRosline.setValue('DESCRIPTION',rosline.getString('DESCRIPTION'), 2L)
     dupRosline.setValue('LINETYPE',rosline.getString('LINETYPE'), 2L)
     dupRosline.setValue('ITEMNUM',rosline.getString('ITEMNUM'), 2L)
     dupRosline.setValue('ASSETNUM',rosline.getString('ASSETNUM'), 2L)
     dupRosline.setValue('QUANTITY',rosline.getDouble('QUANTITY'), 2L)
     dupRosline.setValue('ORDERUNIT',rosline.getString('ORDERUNIT'), 2L)
     dupRosline.setValue('REFUND',rosline.getBoolean('REFUND'), 2L)
     #dupRosline.setValue('ORDERUNIT',rosline.getString('ORDERUNIT'), 2L)
     rosline = roslineSet.moveNext()