CREATE TABLE [dbo].[Tipo_Faixa_Comissao] (
    [cd_tipo_faixa_comissao] INT          NOT NULL,
    [nm_tipo_faixa_comissao] VARCHAR (40) NULL,
    [sg_tipo_faixa_comissao] CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Faixa_Comissao] PRIMARY KEY CLUSTERED ([cd_tipo_faixa_comissao] ASC) WITH (FILLFACTOR = 90)
);

