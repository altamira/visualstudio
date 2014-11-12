CREATE TABLE [dbo].[Beneficio_Composicao] (
    [cd_beneficio_composicao] INT          NOT NULL,
    [cd_beneficio]            INT          NOT NULL,
    [dt_inicio_validade]      DATETIME     NULL,
    [dt_fim_validade]         DATETIME     NULL,
    [vl_beneficio]            FLOAT (53)   NULL,
    [ic_aviso_limite]         CHAR (1)     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [nm_obs_beneficio]        VARCHAR (40) NULL,
    [ic_bloqueio_limite]      CHAR (1)     NULL,
    CONSTRAINT [PK_Beneficio_Composicao] PRIMARY KEY CLUSTERED ([cd_beneficio_composicao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Beneficio_Composicao_Beneficio] FOREIGN KEY ([cd_beneficio]) REFERENCES [dbo].[Beneficio] ([cd_beneficio])
);

