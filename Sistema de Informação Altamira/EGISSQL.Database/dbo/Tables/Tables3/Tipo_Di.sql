CREATE TABLE [dbo].[Tipo_Di] (
    [cd_tipo_di]     INT          NOT NULL,
    [nm_tipo_di]     VARCHAR (40) NOT NULL,
    [sg_tipo_di]     CHAR (10)    NOT NULL,
    [cd_usuario]     INT          NOT NULL,
    [dt_usuario]     DATETIME     NOT NULL,
    [cd_sped_fiscal] VARCHAR (15) NULL,
    CONSTRAINT [PK_Tipo_Di] PRIMARY KEY CLUSTERED ([cd_tipo_di] ASC) WITH (FILLFACTOR = 90)
);

