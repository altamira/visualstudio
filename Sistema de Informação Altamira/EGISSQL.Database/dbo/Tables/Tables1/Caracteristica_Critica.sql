CREATE TABLE [dbo].[Caracteristica_Critica] (
    [cd_caracteristica_critica] INT          NOT NULL,
    [nm_caracteristica_critica] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_atualizacao]            DATETIME     NULL,
    [ds_caracteristica_critica] TEXT         NULL,
    CONSTRAINT [PK_Caracteristica_Critica] PRIMARY KEY CLUSTERED ([cd_caracteristica_critica] ASC) WITH (FILLFACTOR = 90)
);

