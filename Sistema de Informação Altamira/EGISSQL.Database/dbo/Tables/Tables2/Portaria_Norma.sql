CREATE TABLE [dbo].[Portaria_Norma] (
    [cd_portaria_norma]         INT           NOT NULL,
    [nm_portaria_norma]         VARCHAR (60)  NULL,
    [cd_identificacao_portaria] VARCHAR (20)  NULL,
    [ds_portaria_norma]         TEXT          NULL,
    [cd_orgao]                  INT           NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [nm_caminho_portaria_norma] VARCHAR (150) NULL,
    [dt_validade_norma]         DATETIME      NULL,
    [ic_status_norma]           CHAR (1)      NULL,
    CONSTRAINT [PK_Portaria_Norma] PRIMARY KEY CLUSTERED ([cd_portaria_norma] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Portaria_Norma_Orgao_Portaria_Norma] FOREIGN KEY ([cd_orgao]) REFERENCES [dbo].[Orgao_Portaria_Norma] ([cd_orgao])
);

