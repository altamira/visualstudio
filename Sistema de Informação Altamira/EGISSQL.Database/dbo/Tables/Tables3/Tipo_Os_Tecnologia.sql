CREATE TABLE [dbo].[Tipo_Os_Tecnologia] (
    [cd_tipo_os_tecnologia] INT          NOT NULL,
    [nm_tipo_os_tecnologia] VARCHAR (30) NOT NULL,
    [sg_tipo_os_tecnologia] CHAR (10)    NOT NULL,
    [cd_imagem]             INT          NOT NULL,
    [cd_usuario]            INT          NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Os_Tecnologia] PRIMARY KEY CLUSTERED ([cd_tipo_os_tecnologia] ASC) WITH (FILLFACTOR = 90)
);

