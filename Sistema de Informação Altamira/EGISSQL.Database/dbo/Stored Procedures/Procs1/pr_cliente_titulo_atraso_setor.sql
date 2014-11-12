create procedure pr_cliente_titulo_atraso_setor
@cd_vendedor int
as
select b.for_dup as 'cliente', sum(b.saldo_dup) as 'Total Atraso',min(b.dt_ven_dup) as 'Vencimento'
from
   CADCLI a, CADMDR b
Where
   a.fan_cli = b.for_dup           and   --Cliente
   a.cv2_cli = @cd_vendedor    and   --Vendedor
   b.dt_pto_dup is null            and   -- data do pagamento
   b.dt_ven_dup < getdate()-1    and   -- data do vencimento
   b.vlr_dup       > 0
Group by b.for_dup
order by 3 desc,1
