CREATE TABLE [dbo].[Forma_Cobranca] (
    [cd_forma_cobranca] INT          NOT NULL,
    [nm_forma_cobranca] VARCHAR (40) NULL,
    [sg_forma_cobranca] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Forma_Cobranca] PRIMARY KEY CLUSTERED ([cd_forma_cobranca] ASC) WITH (FILLFACTOR = 90)
);

