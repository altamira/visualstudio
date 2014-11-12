CREATE TABLE [dbo].[Desconto_Comissao] (
    [cd_desconto_comissao]      INT          NOT NULL,
    [nm_desconto_comissao]      VARCHAR (40) NULL,
    [sg_desconto_comissao]      CHAR (10)    NULL,
    [pc_comissao_desc_comissao] FLOAT (53)   NULL,
    [pc_ini_desconto_comissao]  FLOAT (53)   NULL,
    [pc_fim_desconto_comissao]  FLOAT (53)   NULL,
    [nm_obs_desconto_comissao]  VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_tipo_desconto_comissao] INT          NULL,
    CONSTRAINT [PK_Desconto_Comissao] PRIMARY KEY CLUSTERED ([cd_desconto_comissao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Desconto_Comissao_Tipo_Desconto_Comissao] FOREIGN KEY ([cd_tipo_desconto_comissao]) REFERENCES [dbo].[Tipo_Desconto_Comissao] ([cd_tipo_desconto_comissao])
);

