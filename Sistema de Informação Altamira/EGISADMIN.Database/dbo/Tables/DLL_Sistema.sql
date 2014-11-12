CREATE TABLE [dbo].[DLL_Sistema] (
    [cd_dll]         INT           NOT NULL,
    [nm_dll]         VARCHAR (40)  NULL,
    [ds_dll]         TEXT          NULL,
    [dt_dll]         DATETIME      NULL,
    [cd_usuario]     INT           NULL,
    [dt_usuario]     DATETIME      NULL,
    [nm_caminho_dll] VARCHAR (100) NULL,
    [nm_arquivo_dll] VARCHAR (100) NULL,
    CONSTRAINT [PK_DLL_Sistema] PRIMARY KEY CLUSTERED ([cd_dll] ASC) WITH (FILLFACTOR = 90)
);

