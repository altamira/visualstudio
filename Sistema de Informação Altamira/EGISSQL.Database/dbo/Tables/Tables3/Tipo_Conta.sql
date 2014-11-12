CREATE TABLE [dbo].[Tipo_Conta] (
    [cd_tipo_conta]       INT          NOT NULL,
    [cd_plano_financeiro] INT          NULL,
    [nm_tipo_conta]       VARCHAR (30) NULL,
    [sg_tipo_conta]       CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Conta] PRIMARY KEY CLUSTERED ([cd_tipo_conta] ASC) WITH (FILLFACTOR = 90)
);

