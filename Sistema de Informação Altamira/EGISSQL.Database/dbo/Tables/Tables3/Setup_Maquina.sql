CREATE TABLE [dbo].[Setup_Maquina] (
    [cd_setup_maquina] INT          NOT NULL,
    [nm_setup_maquina] VARCHAR (30) NOT NULL,
    [sg_setup_maquina] CHAR (10)    NOT NULL,
    [ds_setup_maquina] TEXT         NOT NULL,
    [cd_usuario]       INT          NOT NULL,
    [dt_usuario]       DATETIME     NOT NULL,
    CONSTRAINT [PK_Setup_Maquina] PRIMARY KEY CLUSTERED ([cd_setup_maquina] ASC) WITH (FILLFACTOR = 90)
);

