CREATE TABLE [dbo].[Regiao_Venda] (
    [cd_regiao_venda]       INT          NOT NULL,
    [nm_regiao_venda]       VARCHAR (40) NULL,
    [sg_regiao_venda]       CHAR (15)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [ic_ativa_regiao_venda] CHAR (1)     NULL,
    [ds_regiao_venda]       TEXT         NULL,
    [cd_grupo_regiao]       INT          NULL,
    CONSTRAINT [PK_Regiao_Venda] PRIMARY KEY CLUSTERED ([cd_regiao_venda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Regiao_Venda_Grupo_Regiao] FOREIGN KEY ([cd_grupo_regiao]) REFERENCES [dbo].[Grupo_Regiao] ([cd_grupo_regiao])
);

