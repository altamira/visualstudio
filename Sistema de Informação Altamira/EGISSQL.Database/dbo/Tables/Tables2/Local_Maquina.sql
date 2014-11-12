CREATE TABLE [dbo].[Local_Maquina] (
    [cd_local_maquina] INT          NOT NULL,
    [nm_local_maquina] VARCHAR (30) NOT NULL,
    [sg_local_maquina] CHAR (10)    NOT NULL,
    [cd_usuario]       INT          NOT NULL,
    [dt_usuario]       DATETIME     NOT NULL,
    CONSTRAINT [PK_Local_Maquina] PRIMARY KEY CLUSTERED ([cd_local_maquina] ASC) WITH (FILLFACTOR = 90)
);

