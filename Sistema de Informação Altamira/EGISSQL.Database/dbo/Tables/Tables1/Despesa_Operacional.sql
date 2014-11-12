CREATE TABLE [dbo].[Despesa_Operacional] (
    [cd_despesa_operacional]   INT          NOT NULL,
    [dt_inicio_despesa_operac] DATETIME     NULL,
    [dt_final_despesa_operac]  DATETIME     NULL,
    [dt_despesa_operac]        DATETIME     NULL,
    [cd_vendedor]              INT          NULL,
    [cd_moeda]                 INT          NULL,
    [dt_base_moeda]            DATETIME     NULL,
    [ds_local]                 VARCHAR (50) NULL,
    [cd_tipo_transporte]       INT          NULL,
    [nm_finalidade_despesa_op] VARCHAR (50) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [nm_despesa_operacional]   VARCHAR (30) NULL,
    [sg_despesa_operacional]   CHAR (10)    NULL,
    CONSTRAINT [PK_Despesa_Operacional] PRIMARY KEY CLUSTERED ([cd_despesa_operacional] ASC) WITH (FILLFACTOR = 90)
);

