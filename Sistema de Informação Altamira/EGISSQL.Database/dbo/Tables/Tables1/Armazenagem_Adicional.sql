CREATE TABLE [dbo].[Armazenagem_Adicional] (
    [cd_armazenagem_adicional] INT          NOT NULL,
    [nm_armazenagem_adicional] VARCHAR (40) NULL,
    [sg_armazenagem_adicional] CHAR (10)    NULL,
    [vl_armazenagem_adcional]  FLOAT (53)   NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Armazenagem_Adicional] PRIMARY KEY CLUSTERED ([cd_armazenagem_adicional] ASC) WITH (FILLFACTOR = 90)
);

