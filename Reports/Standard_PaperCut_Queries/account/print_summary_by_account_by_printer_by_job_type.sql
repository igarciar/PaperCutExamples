declare @end_date datetime

set @end_date = getdate()
set @start_date = DATEADD(DAY,-30,@end_date)

SELECT     account4_.account_name                   AS col_0_0_, 
           account4_.sub_name                       AS col_1_0_, 
           account4_.pin                            AS col_2_0_, 
           account4_.sub_pin                        AS col_3_0_, 
           printer1_.display_name                   AS col_4_0_, 
           printerusa0_.paper_size                  AS col_5_0_, 
           printerusa0_.duplex                      AS col_6_0_, 
           Sum(printerusa0_.total_pages)            AS col_7_0_, 
           Sum(printerusa0_.usage_cost)             AS col_8_0_, 
           Count(printerusa0_.printer_usage_log_id) AS col_9_0_, 
           Sum(printerusa0_.total_color_pages)      AS col_10_0_ 
FROM       tbl_printer_usage_log printerusa0_ 
INNER JOIN tbl_printer printer1_ 
ON         printerusa0_.printer_id=printer1_.printer_id 
INNER JOIN tbl_user user2_ 
ON         printerusa0_.used_by_user_id=user2_.user_id 
INNER JOIN tbl_account account3_ 
ON         printerusa0_.charged_to_account_id=account3_.account_id 
INNER JOIN tbl_account account4_ 
ON         printerusa0_.assoc_with_account_id=account4_.account_id 
WHERE      account4_.account_type='SHARED' 
AND        printerusa0_.usage_date>=@start_date 
AND        printerusa0_.usage_allowed='Y'
AND        printerusa0_.refunded='N' 
AND        printerusa0_.printed='Y' 
GROUP BY   account4_.account_type , 
           account4_.account_name , 
           account4_.sub_name , 
           account4_.pin , 
           account4_.sub_pin , 
           printer1_.display_name , 
           printerusa0_.paper_size , 
           printerusa0_.duplex 
ORDER BY   account4_.account_type, 
           Lower(account4_.account_name), 
           Lower(account4_.sub_name), 
           Lower(printer1_.display_name), 
           printerusa0_.paper_size, 
           printerusa0_.duplex