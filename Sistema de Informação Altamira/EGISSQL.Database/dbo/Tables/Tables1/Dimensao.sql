CREATE TABLE [dbo].[Dimensao] (
    [cd_dimensao]          INT          NOT NULL,
    [nm_dimensao]          VARCHAR (60) NULL,
    [nm_fantasia_dimensao] VARCHAR (15) NULL,
    [sg_dimensao]          CHAR (10)    NULL,
    [ic_status_dimesao]    CHAR (1)     NULL,
    [cd_unidade_negocio]   INT          NULL,
    [cd_divisao_unidade]   INT          NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Dimensao] PRIMARY KEY CLUSTERED ([cd_dimensao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Dimensao_Divisao_Unidade_Negocio] FOREIGN KEY ([cd_divisao_unidade]) REFERENCES [dbo].[Divisao_Unidade_Negocio] ([cd_divisao_unidade])
);

