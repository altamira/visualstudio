CREATE TABLE [dbo].[Parametro_Cobranca] (
    [cd_empresa]            INT        NOT NULL,
    [pc_spc_cobranca]       FLOAT (53) NULL,
    [pc_honorario_cobranca] FLOAT (53) NULL,
    [pc_comissao_cobranca]  FLOAT (53) NULL,
    [pc_multa_cobranca]     FLOAT (53) NULL,
    [cd_usuario]            INT        NULL,
    [dt_usuario]            DATETIME   NULL,
    CONSTRAINT [PK_Parametro_Cobranca] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

