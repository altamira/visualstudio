CREATE TABLE [dbo].[Destino_Chegada] (
    [cd_destino_chegada] INT          NOT NULL,
    [nm_destino_chegada] VARCHAR (40) NULL,
    [sg_destino_chegada] CHAR (10)    NULL,
    [ds_destino_chegada] TEXT         NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Destino_Chegada] PRIMARY KEY CLUSTERED ([cd_destino_chegada] ASC) WITH (FILLFACTOR = 90)
);

