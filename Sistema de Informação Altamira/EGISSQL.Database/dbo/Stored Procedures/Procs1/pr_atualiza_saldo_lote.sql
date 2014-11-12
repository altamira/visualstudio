
CREATE PROCEDURE pr_atualiza_saldo_lote
@ic_parametro        int = 0,         --Parametro de Cálculo, não é usado.
@cd_lote_produto     int = 0,         --Lote do Produto que será atualizado 
@cd_produto          int,             --Produto
@qt_produto          float,           --Quantidade
@ic_validade         char(1),         --Checa a Validade
@ic_tipo_calculo     int,             --Tipo de Cálculo
@cd_usuario          int,             --Usuário
@nm_ref_lote_produto varchar(25) = '' --Identificação do Lote do Produto
                                      --Quando estiver diferente de vazio, faz a busca do @cd_lote_produto


as

--Tipo de Cálculo
--1 -> Entrada de Quantidade no Saldo do Lote
--11-> Entrada de Quantidade no Saldo do Lote - Reserva
--2 -> Saída   de Quantidade no Saldo do Lote
--22-> Saída   de Quantidade no Saldo do Lote - Reserva
--3 -> Mostra  os Lotes conforme o Produto
--4 -> Mostra  os Lotes conforme o Produto, mas com um formato Especial- Loja

if (@nm_ref_lote_produto<>'' ) and (@cd_lote_produto=0) 
begin

  --Busca o Lote do Produto conforme a Referência
  select 
    @cd_lote_produto = isnull(cd_lote_produto,0)
  from
    Lote_Produto
  where
    nm_ref_lote_produto = @nm_ref_lote_produto
    
end

--print @cd_lote_produto
--print @nm_ref_lote_produto
--print @ic_tipo_calculo

----------------------------------------------------------------------------------------------------------
--Verifica se Existe o Lote e Faz a Geração Automática
----------------------------------------------------------------------------------------------------------
if @cd_lote_produto = 0
begin

  select @cd_lote_produto = max(isnull(cd_lote_produto,0))+1 from Lote_Produto

  if @cd_lote_produto = 0
  begin
     set @cd_lote_produto = 1  
  end

  if @cd_lote_produto>0
  begin

    insert into Lote_produto
    select
       @cd_lote_produto,
       @nm_ref_lote_produto,
       @nm_ref_lote_produto,
       'A',
       getdate(),
       getdate(),
       getdate(),
       'S',
       getdate(),
       'S',
       1,
       0,   
       0,   
       getdate(),
       'Gerado Automaticamente',
       null,
       null,
       'S',
       0 

       --item
       insert Lote_Produto_item
         (cd_lote_produto,
         cd_produto,
         qt_produto_lote_produto ) values
         (@cd_lote_produto, @cd_produto, 0 )
    end

end


----------------------------------------------------------------------------------------------------------
--Entrada de Quantidade no Saldo do Lote
----------------------------------------------------------------------------------------------------------

if @ic_tipo_calculo=1
begin
  
  --Verifica se o Lote se encontra na Tabela Lote_Produto_Saldo
  if not exists(select cd_lote_produto from Lote_Produto_Saldo where @cd_lote_produto = cd_lote_produto and
                                                                     @cd_produto      = cd_produto   )  
     and @cd_lote_produto>0

  begin
    insert
      Lote_Produto_Saldo (
        cd_produto,
        cd_lote_produto,
        qt_saldo_reserva_lote,
        qt_saldo_atual_lote,
        cd_usuario,
        dt_usuario )
      select
        @cd_produto,
        @cd_lote_produto,
        0,
        0,
        @cd_usuario,
        getdate()
   end

   --Atualiza o Saldo do Lote = Entrada
   
   update
     Lote_Produto_Saldo
   set
     qt_saldo_atual_lote   = isnull(qt_saldo_atual_lote,0)   + isnull(@qt_produto,0)
   where
     cd_lote_produto = @cd_lote_produto and 
     cd_produto      = @cd_produto

end

----------------------------------------------------------------------------------------------------------
--Entrada de Quantidade de Reserva no Saldo do Lote
----------------------------------------------------------------------------------------------------------

if @ic_tipo_calculo=11
begin
  --print @ic_tipo_calculo
  
  --Verifica se o Lote se encontra na Tabela Lote_Produto_Saldo
  if not exists(select cd_lote_produto from Lote_Produto_Saldo where @cd_lote_produto = cd_lote_produto and
                                                                     @cd_produto      = cd_produto   )
     and @cd_lote_produto>0

  begin
    insert
      Lote_Produto_Saldo (
        cd_produto,
        cd_lote_produto,
        qt_saldo_reserva_lote,
        qt_saldo_atual_lote,
        cd_usuario,
        dt_usuario )
      select
        @cd_produto,
        @cd_lote_produto,
        0,
        0,
        @cd_usuario,
        getdate()
   end

   --Atualiza o Saldo do Lote = Entrada
--   print 'Lote : '+@cd_lote_produto
--   print @qt_produto
   
   update
     Lote_Produto_Saldo
   set
     qt_saldo_reserva_lote = isnull(qt_saldo_reserva_lote,0) + isnull(@qt_produto,0)
   where
     cd_lote_produto = @cd_lote_produto and 
     cd_produto      = @cd_produto


end


----------------------------------------------------------------------------------------------------------
--Saída  de Quantidade no Saldo do Lote
----------------------------------------------------------------------------------------------------------

if @ic_tipo_calculo=2
begin

  --Verifica se o Lote se encontra na Tabela Lote_Produto_Saldo
  if not exists(select cd_lote_produto from Lote_Produto_Saldo where @cd_lote_produto = cd_lote_produto and
                                                                     @cd_produto      = cd_produto   )
     and @cd_lote_produto>0

  begin
    insert
      Lote_Produto_Saldo (
        cd_produto,
        cd_lote_produto,
        qt_saldo_reserva_lote,
        qt_saldo_atual_lote,
        cd_usuario,
        dt_usuario )
      select
        @cd_produto,
        @cd_lote_produto,
        0,
        0,
        @cd_usuario,
        getdate()
   end

   --Atualiza o Saldo do Lote 
   
   update
     Lote_Produto_Saldo
   set
     qt_saldo_atual_lote = isnull(qt_saldo_atual_lote,0) - isnull(@qt_produto,0)
   where
     cd_lote_produto = @cd_lote_produto and 
     cd_produto      = @cd_produto

--   select * from lote_produto_saldo   

end

----------------------------------------------------------------------------------------------------------
--Saída  de Quantidade no Saldo do Lote Reserva
----------------------------------------------------------------------------------------------------------

if @ic_tipo_calculo=22
begin

  --print @ic_tipo_calculo

  --Verifica se o Lote se encontra na Tabela Lote_Produto_Saldo
  if not exists(select cd_lote_produto from Lote_Produto_Saldo where @cd_lote_produto = cd_lote_produto and
                                                                     @cd_produto      = cd_produto   )
     and @cd_lote_produto>0

  begin
    insert
      Lote_Produto_Saldo (
        cd_produto,
        cd_lote_produto,
        qt_saldo_reserva_lote,
        qt_saldo_atual_lote,
        cd_usuario,
        dt_usuario )
      select
        @cd_produto,
        @cd_lote_produto,
        0,
        0,
        @cd_usuario,
        getdate()
   end

   --Atualiza o Saldo do Lote = Entrada

   --print @cd_lote_produto
   --print @qt_produto
   
   update
     Lote_Produto_Saldo
   set
     qt_saldo_reserva_lote = isnull(qt_saldo_reserva_lote,0) - isnull(@qt_produto,0)
   where
     cd_lote_produto = @cd_lote_produto and 
     cd_produto      = @cd_produto

--   select * from lote_produto_saldo   

end

----------------------------------------------------------------------------------------------------------
--Localizar os lotes que existem para o Produto e que possuem saldo - LOJA
----------------------------------------------------------------------------------------------------------
if @ic_tipo_calculo=3  

begin
   select distinct
     0                                as Selecao,
     l.nm_ref_lote_produto            as Lote,
     lp.cd_lote_produto,
     lp.cd_produto,
     lp.qt_produto_lote_produto,
     ls.qt_saldo_reserva_lote         as SaldoReserva,
     ls.qt_saldo_atual_lote           as SaldoAtual,
     l.dt_entrada_lote_produto        as Entrada,
     l.dt_inicial_lote_produto        as InicioValidade,
     l.dt_final_lote_produto          as FimValidade,
     cast( getdate()-
     l.dt_final_lote_produto as int)  as Dias,
     p.nm_pais                        as Pais,
     l.nm_obs_lote_produto            as Observacao,
     case when getdate()>l.dt_final_lote_produto then 'Vencido' else '' end as Status,
     pro.cd_mascara_produto as Mascara,
     pro.nm_produto as DescricaoProduto,
     und.sg_unidade_medida,
     lp.cd_movimento_lote,
     lp.cd_movimento_lote_origem,
     lp.ic_tipo_movimento_lote,
     loj.nm_fantasia_loja,
     lp.cd_peca_item_lote,
     lp.cd_box_item_lote,
     ( case when lp.ic_status_item_lote = 'A' then 'Aberto' 
            when lp.ic_status_item_lote = 'B' then 'Bloqueado'
            end ) as 'ic_status_item_lote',
     c.nm_cor,
     d.nm_desenho_projeto,
     lp.qt_reserva_m2_item_lote,
     lp.qt_saldo_m2_item_lote,
     lp.qt_saldo_ml_item_lote,
     lp.qt_largura_item_lote,
     lp.cd_tipo_desenho,
     lp.qt_comp_item_lote
   from
     Lote_Produto_item lp 
     inner join lote_produto_saldo ls on ls.cd_lote_produto = lp.cd_lote_produto
     inner join      lote_produto l        on l.cd_lote_produto  = lp.cd_lote_produto
     left outer join pais p                on p.cd_pais          = l.cd_pais
     left outer join produto pro           on lp.cd_produto      = pro.cd_produto
     left outer join unidade_medida und    on pro.cd_unidade_medida = und.cd_unidade_medida
     left outer join Loja loj on loj.cd_loja = lp.cd_loja
     left outer join cor c on c.cd_cor = lp.cd_cor
     left outer join Processo_Producao pp on pp.cd_processo = l.cd_processo
     left outer join Desenho_projeto d on d.cd_desenho_projeto = lp.cd_tipo_desenho and
                                          d.cd_projeto = pp.cd_projeto
                       
   where
     lp.cd_produto = @cd_produto and
     lp.cd_lote_produto = (case when @cd_lote_produto = 0 then lp.cd_lote_produto 
                                else @cd_lote_produto end )
   order by
     l.dt_final_lote_produto,
     l.dt_entrada_lote_produto

end

----------------------------------------------------------------------------------------------------------
--Localizar os lotes que existem para o Produto e que possuem saldo
----------------------------------------------------------------------------------------------------------
if @ic_tipo_calculo=4
begin
   select distinct
     0                                as Selecao,
     l.nm_ref_lote_produto            as Lote,
     lp.cd_lote_produto,
     lp.cd_produto,
     lp.qt_produto_lote_produto,
     ls.qt_saldo_reserva_lote         as SaldoReserva,
     ls.qt_saldo_atual_lote           as SaldoAtual,
     l.dt_entrada_lote_produto        as Entrada,
     l.dt_inicial_lote_produto        as InicioValidade,
     l.dt_final_lote_produto          as FimValidade,
     cast( getdate()-
     l.dt_final_lote_produto as int)  as Dias,
     p.nm_pais                        as Pais,
     l.nm_obs_lote_produto            as Observacao,
     case when getdate()>l.dt_final_lote_produto then 'Vencido' else '' end as Status,
     pro.cd_mascara_produto as Mascara,
     pro.nm_produto as DescricaoProduto,
     und.sg_unidade_medida,
     lp.cd_movimento_lote,
     lp.cd_movimento_lote_origem,
     lp.ic_tipo_movimento_lote,
     ( case when lp.ic_status_item_lote = 'A' then 'Aberto' 
            when lp.ic_status_item_lote = 'B' then 'Bloqueado'
            end ) as 'ic_status_item_lote'
   from
     Lote_Produto_item lp 
     inner join lote_produto_saldo ls on ls.cd_lote_produto = lp.cd_lote_produto
     inner join      lote_produto l        on l.cd_lote_produto  = lp.cd_lote_produto
     left outer join pais p                on p.cd_pais          = l.cd_pais
     left outer join produto pro           on lp.cd_produto      = pro.cd_produto
     left outer join unidade_medida und    on pro.cd_unidade_medida = und.cd_unidade_medida
     left outer join Processo_Producao pp  on pp.cd_processo = l.cd_processo
                       
   where
     lp.cd_produto = @cd_produto and
     lp.cd_lote_produto = (case when @cd_lote_produto = 0 then lp.cd_lote_produto 
                                else @cd_lote_produto end )
   order by
     l.dt_final_lote_produto,
     l.dt_entrada_lote_produto

end

 
--select * from lote_produto
--select * from lote_produto_saldo 
--select * from lote_produto_item

