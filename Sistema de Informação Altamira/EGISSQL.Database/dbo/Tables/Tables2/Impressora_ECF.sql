CREATE TABLE [dbo].[Impressora_ECF] (
    [cd_impressora_ecf]            INT           NOT NULL,
    [nm_impressora_ecf]            VARCHAR (40)  NULL,
    [nm_fantasia_impressora_ecf]   VARCHAR (15)  NULL,
    [nm_modelo_impressora_ecf]     VARCHAR (25)  NULL,
    [nm_dll_impressora_ecf]        VARCHAR (100) NULL,
    [nm_local_dll_impressora_ecf]  VARCHAR (100) NULL,
    [nm_versao_dll_impressora_ecf] VARCHAR (40)  NULL,
    [cd_usuario]                   INT           NULL,
    [dt_usuario]                   DATETIME      NULL,
    CONSTRAINT [PK_Impressora_ECF] PRIMARY KEY CLUSTERED ([cd_impressora_ecf] ASC) WITH (FILLFACTOR = 90)
);

