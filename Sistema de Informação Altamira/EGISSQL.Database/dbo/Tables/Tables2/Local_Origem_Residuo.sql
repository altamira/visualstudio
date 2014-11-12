CREATE TABLE [dbo].[Local_Origem_Residuo] (
    [cd_local_origem_residuo] INT          NOT NULL,
    [nm_local_origem_residuo] VARCHAR (40) NULL,
    [sg_local_origem_residuo] CHAR (10)    NULL,
    [ic_ativo_local_origem]   CHAR (1)     NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_usuario]              INT          NULL,
    CONSTRAINT [PK_Local_Origem_Residuo] PRIMARY KEY CLUSTERED ([cd_local_origem_residuo] ASC) WITH (FILLFACTOR = 90)
);

