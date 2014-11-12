CREATE TABLE [dbo].[Local_Servidor] (
    [cd_local_servidor] INT          NOT NULL,
    [nm_local_servidor] VARCHAR (30) NOT NULL,
    [sg_local_servidor] VARCHAR (10) NOT NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    [cd_pais]           INT          NULL,
    CONSTRAINT [PK_Local_servidor] PRIMARY KEY NONCLUSTERED ([cd_local_servidor] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Local_Servidor_Pais] FOREIGN KEY ([cd_pais]) REFERENCES [dbo].[Pais] ([cd_pais])
);

