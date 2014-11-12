CREATE TABLE [dbo].[IML] (
    [cd_iml]     INT          NOT NULL,
    [nm_iml]     VARCHAR (40) NULL,
    [sg_iml]     CHAR (10)    NULL,
    [cd_usuario] INT          NULL,
    [dt_usuario] DATETIME     NULL,
    CONSTRAINT [PK_IML] PRIMARY KEY CLUSTERED ([cd_iml] ASC) WITH (FILLFACTOR = 90)
);

