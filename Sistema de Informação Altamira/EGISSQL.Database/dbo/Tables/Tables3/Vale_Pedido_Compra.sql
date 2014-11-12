CREATE TABLE [dbo].[Vale_Pedido_Compra] (
    [cd_vale]               INT          NOT NULL,
    [dt_vale]               DATETIME     NULL,
    [cd_pedido_compra]      INT          NULL,
    [cd_item_pedido_compra] INT          NULL,
    [qt_vale_item_pedido]   FLOAT (53)   NULL,
    [nm_obs_vale_pedido]    VARCHAR (40) NULL,
    [cd_usuario_baixa_vale] INT          NULL,
    [dt_baixa_vale]         DATETIME     NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Vale_Pedido_Compra] PRIMARY KEY CLUSTERED ([cd_vale] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Vale_Pedido_Compra_Pedido_Compra] FOREIGN KEY ([cd_pedido_compra]) REFERENCES [dbo].[Pedido_Compra] ([cd_pedido_compra])
);


GO
CREATE TRIGGER td_vale_pedido_compra_recebimento
ON Vale_Pedido_Compra
AFTER DELETE
AS 

declare @cd_pedido_compra int

select
  @cd_pedido_compra = isnull(cd_pedido_compra,0)
from
  deleted

if @cd_pedido_compra>0
begin
  
  update
    pedido_compra
  set
    cd_status_pedido = 8 --Pedido em Aberto
 
  where
    cd_pedido_compra = @cd_pedido_compra

  
end

--select * from status_pedido  
--select 

GO
CREATE TRIGGER ti_vale_pedido_compra_recebimento
ON Vale_Pedido_Compra
AFTER UPDATE, INSERT 
AS 

declare @cd_pedido_compra int
declare @cd_status_pedido int
declare @dt_baixa         datetime

select
  @cd_pedido_compra = isnull(cd_pedido_compra,0),
  @dt_baixa         = dt_baixa_vale
from
  inserted

if @cd_pedido_compra>0
begin

  select
    @cd_status_pedido = isnull(cd_status_pedido,8)
  from
    Parametro_Suprimento
  where
    cd_empresa = dbo.fn_empresa()
  
  update
    pedido_compra
  set
    cd_status_pedido = case when @dt_baixa is null then @cd_status_pedido else 8 end
 
  where
    cd_pedido_compra = @cd_pedido_compra

  
end

--select * from status_pedido  
