CREATE TABLE [dbo].[Divisao_Regiao] (
    [cd_grupo_div_regiao] INT          NOT NULL,
    [cd_divisao_regiao]   INT          NOT NULL,
    [cd_vendedor]         INT          NOT NULL,
    [nm_divisao_regiao]   VARCHAR (40) NOT NULL,
    [sg_divisao_regiao]   CHAR (10)    NOT NULL,
    [ic_divisao_regiao]   CHAR (1)     NULL,
    [ic_grupo_regiao]     CHAR (1)     NULL,
    [cd_usuario]          INT          NOT NULL,
    [dt_usuario]          DATETIME     NOT NULL,
    [cd_vendedor_interno] INT          NULL,
    CONSTRAINT [PK_Divisao_regiao] PRIMARY KEY CLUSTERED ([cd_grupo_div_regiao] ASC, [cd_divisao_regiao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Divisao_Regiao_Vendedor] FOREIGN KEY ([cd_vendedor_interno]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

