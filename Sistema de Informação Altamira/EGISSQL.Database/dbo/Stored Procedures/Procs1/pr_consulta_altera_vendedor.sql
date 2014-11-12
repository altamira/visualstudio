
CREATE PROCEDURE pr_consulta_altera_vendedor

@ic_parametro                  int,
@cd_pedido_venda               int,
@cd_nota_saida                 int,
@dt_inicial                    datetime,    --Data Inicial
@dt_final                      datetime     --Data Final

AS
----------------------------------------------------------
if @ic_parametro = 1 -- Pesquisa por Pedido de Venda
----------------------------------------------------------
begin
  -----------------------------------------------------------
  if @cd_pedido_venda = 0 -- Escolhe todos os Pedidos
  -----------------------------------------------------------
  begin
  SELECT     Pedido_Venda.cd_pedido_venda       AS Pedido, 
             Pedido_Venda.vl_total_pedido_venda as VlTotal , 
             Pedido_Venda.vl_total_pedido_venda as vl_produto, 
             Pedido_Venda.dt_pedido_venda       AS Emissao, 
             Pedido_Venda.cd_vendedor_interno,
             Pedido_Venda.cd_vendedor,
             Cliente.nm_fantasia_cliente        AS Cliente, 
             vi.nm_fantasia_vendedor            as 'VendedorInterno',
             ve.nm_fantasia_vendedor            as 'VendedorExterno',
             Pedido_Venda.pc_comissao_especifico,
             isnull(Pedido_Venda.ic_comissao_pedido_venda,'S') as ic_comissao_pedido_venda

  FROM       Pedido_Venda with (nolock) 
             INNER JOIN
             Cliente     ON Pedido_Venda.cd_cliente = Cliente.cd_cliente      left outer join
             Vendedor vi on vi.cd_vendedor = Pedido_Venda.cd_vendedor_interno left outer join
             Vendedor ve on ve.cd_vendedor = Pedido_Venda.cd_vendedor
  where

    --Carlos 27.06.2005
    --Pedido_Venda.dt_cancelamento_pedido is null and
    --Pedido_Venda.cd_status_pedido not in (7,14) and
    Pedido_Venda.dt_pedido_venda between @dt_inicial and @dt_final
 
  order by Pedido_Venda.dt_pedido_venda desc, Pedido_Venda.cd_pedido_venda desc
  end

  -----------------------------------
  else -- Escolhe apenas 1 Pedido de Venda
  ------------------------------------
  begin
 
  SELECT     Pedido_Venda.cd_pedido_venda       AS Pedido, 
             Pedido_Venda.vl_total_pedido_venda as VlTotal , 
             Pedido_Venda.vl_total_pedido_venda as vl_produto, 
             Pedido_Venda.dt_pedido_venda       AS Emissao, 
             Pedido_Venda.cd_vendedor_interno,
             Pedido_Venda.cd_vendedor,
             Cliente.nm_fantasia_cliente AS Cliente, 
             vi.nm_fantasia_vendedor as 'VendedorInterno',
             ve.nm_fantasia_vendedor as 'VendedorExterno',
             Pedido_Venda.pc_comissao_especifico,
             isnull(Pedido_Venda.ic_comissao_pedido_venda,'S') as ic_comissao_pedido_venda


  FROM       Pedido_Venda INNER JOIN
             Cliente     ON Pedido_Venda.cd_cliente = Cliente.cd_cliente      left outer join
             Vendedor vi on vi.cd_vendedor = Pedido_Venda.cd_vendedor_interno left outer join
             Vendedor ve on ve.cd_vendedor = Pedido_Venda.cd_vendedor
  where
   --Carlos 27.06.2005
   -- Pedido_Venda.dt_cancelamento_pedido is null and
   --Pedido_Venda.cd_status_pedido not in (7,14) and
    Pedido_Venda.cd_pedido_venda = @cd_pedido_venda 
 
  order by Pedido_Venda.dt_pedido_venda desc, Pedido_Venda.cd_pedido_venda desc
  end

end


----------------------------------
if @ic_parametro = 2 -- Escolha por Nota Fiscal
---------------------------------
begin

  -------------------------------------------------------------  
  if @cd_nota_saida = 0 -- Escolha de todas as notas fiscais.
  -------------------------------------------------------------
  begin

    SELECT     --Nota_Saida.cd_nota_saida      AS Nota, 

      Nota_Saida.cd_nota_saida,

      case when isnull(Nota_Saida.cd_identificacao_nota_saida,0)>0 then
         Nota_Saida.cd_identificacao_nota_saida
      else
         Nota_Saida.cd_nota_saida                  
      end                                   as 'Nota',

      Nota_Saida.dt_nota_saida               AS Emissao, 
               Cliente.nm_fantasia_cliente   AS Cliente, 
               Nota_Saida.vl_total           AS VLTotal,
               Nota_Saida.vl_produto         as vl_produto, 
               Nota_Saida.cd_status_nota     AS Status, 
               Nota_Saida.cd_vendedor,             
               Vendedor.nm_fantasia_vendedor AS VendedorExterno,
	       ( select top 1 v.nm_fantasia_vendedor 
                 from Pedido_Venda p with (nolock) 
                 inner join Nota_Saida_Item ns on 
                 ns.cd_pedido_venda = p.cd_pedido_venda
                 inner join Vendedor v on 
                 p.cd_vendedor_interno = v.cd_vendedor
                 where ns.cd_nota_saida = Nota_Saida.cd_nota_saida ) as 'VendedorInterno',

	       ( select top 1 isnull(p.ic_comissao_pedido_venda,'S')
                 from Pedido_Venda p with (nolock) 
                 inner join Nota_Saida_Item ns on 
                 ns.cd_pedido_venda = p.cd_pedido_venda
                 where ns.cd_nota_saida = Nota_Saida.cd_nota_saida ) as 'ic_comissao_pedido_venda'


    FROM       Nota_Saida with (nolock)                                 Inner join
               Cliente    ON Nota_Saida.cd_cliente = Cliente.cd_cliente INNER JOIN
               Vendedor   ON Nota_Saida.cd_vendedor = Vendedor.cd_vendedor   
    where
             --Carlos 27.06.2005
             --Nota_Saida.dt_cancel_nota_saida is null and
             --Nota_Saida.cd_status_nota not in ( 3, 4 , 7) and
               Nota_Saida.dt_nota_saida between @dt_inicial and @dt_final and
               Nota_Saida.dt_cancel_nota_saida is null

    --select * from nota_saida

    order by Nota_Saida.dt_nota_saida desc, NOta_Saida.cd_nota_saida desc

   end
   -----------------------------------
   else -- Pesquisa Apenas 1 Nota Fiscal
   -----------------------------------
   begin

     SELECT     
                --Nota_Saida.cd_nota_saida      AS Nota, 
       Nota_Saida.cd_nota_saida,

       case when isnull(Nota_Saida.cd_identificacao_nota_saida,0)>0 then
          Nota_Saida.cd_identificacao_nota_saida
       else
          Nota_Saida.cd_nota_saida                  
       end                                     as 'Nota',

                Nota_Saida.dt_nota_saida      AS Emissao, 
                Cliente.nm_fantasia_cliente   AS Cliente, 
                Nota_Saida.vl_total           AS VLTotal, 
                Nota_Saida.vl_produto         as vl_produto, 
                Nota_Saida.cd_status_nota     AS Status, 
                Nota_Saida.cd_vendedor,             
                Vendedor.nm_fantasia_vendedor AS VendedorExterno,
	       ( select top 1 v.nm_fantasia_vendedor 

                 from Pedido_Venda p with (nolock) 
                 inner join Nota_Saida_Item ns on 
                 ns.cd_pedido_venda = p.cd_pedido_venda
                 inner join Vendedor v on 
                 p.cd_vendedor_interno = v.cd_vendedor
                 where ns.cd_nota_saida = Nota_Saida.cd_nota_saida ) as 'VendedorInterno',

	       ( select top 1 isnull(p.ic_comissao_pedido_venda,'S')
                 from Pedido_Venda p 
                 inner join Nota_Saida_Item ns on 
                 ns.cd_pedido_venda = p.cd_pedido_venda
                 where ns.cd_nota_saida = Nota_Saida.cd_nota_saida ) as 'ic_comissao_pedido_venda'


     FROM       Nota_Saida left outer join -- Coloquei Left outer join para que ele traga, mesmo que o Cliente e o vendedor esteja vazio.
                Cliente    ON Nota_Saida.cd_cliente  = Cliente.cd_cliente left outer join
                Vendedor   ON Nota_Saida.cd_vendedor = Vendedor.cd_vendedor   
     where
                --Carlos 27.06.2005
                --Nota_Saida.dt_cancel_nota_saida is null and
                --Nota_Saida.cd_status_nota not in ( 3, 4 , 7) and
                Nota_Saida.cd_nota_saida = @cd_nota_saida and
                Nota_Saida.dt_cancel_nota_saida is null

     order by Nota_Saida.dt_nota_saida desc, NOta_Saida.cd_nota_saida desc       

   end
 
end




