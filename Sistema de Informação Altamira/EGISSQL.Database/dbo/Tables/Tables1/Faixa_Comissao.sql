CREATE TABLE [dbo].[Faixa_Comissao] (
    [cd_faixa_comissao]          INT          NOT NULL,
    [cd_tipo_faixa_comissao]     INT          NULL,
    [nm_faixa_comissao]          VARCHAR (40) NULL,
    [sg_faixa_comissao]          CHAR (10)    NULL,
    [pc_comissao_faixa_comissao] FLOAT (53)   NULL,
    [vl_inicial_faixa_comissao]  FLOAT (53)   NULL,
    [vl_final_faixa_comissao]    FLOAT (53)   NULL,
    [nm_obs_faixa_comissao]      VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Faixa_Comissao] PRIMARY KEY CLUSTERED ([cd_faixa_comissao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Faixa_Comissao_Tipo_Faixa_Comissao] FOREIGN KEY ([cd_tipo_faixa_comissao]) REFERENCES [dbo].[Tipo_Faixa_Comissao] ([cd_tipo_faixa_comissao])
);

