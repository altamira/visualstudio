CREATE TABLE [dbo].[Status_Nota_Entrada] (
    [cd_status_nota] INT          NOT NULL,
    [nm_status_nota] VARCHAR (30) NULL,
    [sg_status_nota] CHAR (10)    NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Status_Nota_Entrada] PRIMARY KEY CLUSTERED ([cd_status_nota] ASC)
);

