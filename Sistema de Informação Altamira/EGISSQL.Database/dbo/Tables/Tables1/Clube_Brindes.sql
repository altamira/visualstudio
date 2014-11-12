CREATE TABLE [dbo].[Clube_Brindes] (
    [cd_brinde]  INT          NOT NULL,
    [nm_brinde]  VARCHAR (60) NULL,
    [cd_usuario] INT          NULL,
    [dt_usuario] DATETIME     NULL,
    CONSTRAINT [PK_Clube_Brindes] PRIMARY KEY CLUSTERED ([cd_brinde] ASC)
);

