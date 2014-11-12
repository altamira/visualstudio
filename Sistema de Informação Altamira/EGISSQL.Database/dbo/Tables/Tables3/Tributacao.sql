CREATE TABLE [dbo].[Tributacao] (
    [cd_tributacao]         INT          NOT NULL,
    [nm_tributacao]         VARCHAR (50) NULL,
    [sg_tributacao]         CHAR (10)    NULL,
    [cd_tipo_operacao]      INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_usuario]            INT          NULL,
    [cd_tributacao_icms]    INT          NULL,
    [cd_modalidade_icms]    INT          NULL,
    [cd_modalidade_icms_st] INT          NULL,
    [cd_tributacao_ipi]     INT          NULL,
    [cd_tributacao_pis]     INT          NULL,
    [cd_tributacao_cofins]  INT          NULL,
    CONSTRAINT [PK_Tributacao] PRIMARY KEY CLUSTERED ([cd_tributacao] ASC) WITH (FILLFACTOR = 90)
);


GO
--tr_apagar_tributacao
-------------------------------------------------------------------------
--Polimold Industrial S/A                           2001
--Trigger : SQL Server Microsoft 7.0
--Elias Pereira da Silva
--Rotina de Exclusao de tributacao
--Data        :   26.09.2001
--Atualizaçao :
-------------------------------------------------------------------------
create trigger tr_apagar_tributacao on Tributacao
for delete
as
begin
  declare @cd_tributacao int

  select 
    @cd_tributacao = cd_tributacao
  from 
    deleted

  if exists(select
              cd_tributacao
            from
              Composicao_tributacao
            where
              cd_tributacao = @cd_tributacao)
      raiserror('Deleçao nao Permitida. Existem registros de Composiçao de Tributaçao usando esta Tributaçao.',16,1)
end

