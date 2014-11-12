
create procedure pr_zera_produto_saldo
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2003                     
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Igor Augusto C. Gama
--Banco Dados      : EGISSQL
--Objetivo         : Zera Produto Saldo
--                 : Para Geração dos novos saldos de estoque
--Data             : 24.02.2003
--Atualizado       : 
--                 : 25/04/2003 - Incluído parâmetro para zerar por produto ou por
--                              - fase.  - Daniel C. Neto.
--                 : 15.05.2005 - Acerto do Procedimento - Carlos Fernandes
-----------------------------------------------------------------------------------

@ic_parametro    as int = 0,
@cd_produto      as int = 0,
@cd_fase_produto as int = 0

--Parametro
--0=> Zera os atributos da Tabela Produto Saldo
--1=> Deleta todos os registros da Tabela Produto Saldo
as


begin tran

--select * from Produto_Saldo

if @ic_parametro = 0
begin
  update 
    Produto_Saldo
  set
    qt_saldo_reserva_produto = 0,
    qt_saldo_atual_produto   = 0,
    qt_implantacao_produto   = 0,
    qt_consig_produto        = 0,
    qt_terceiro_produto      = 0,
    qt_entrada_produto       = 0,
    qt_saida_produto         = 0,
    qt_reserva_saldo_produto = 0
    --Carlos 15.05.2005 -> Verificar futuramente se é necesário zerar os outros atributos

  where 
    ((cd_produto = @cd_produto) or 
     (@cd_produto = 0 )) and 
    ((cd_fase_produto = @cd_fase_produto) or
     (@cd_fase_produto = 0))


end

  
if @ic_parametro = 1 --Deleção Total de Registros
begin
  delete from 
    Produto_Saldo 
  where 
    ((cd_produto = @cd_produto) or 
     (@cd_produto = 0 )) and 
    ((cd_fase_produto = @cd_fase_produto) or
     (@cd_fase_produto = 0))
end

if @@error = 0 
   begin
     commit tran
   end
else
   begin
     raiserror ('Atenção... Não foi possível zerar a tabela Produto Saldo, pois ocorreram erros !',16,1)
     rollback tran
   end

