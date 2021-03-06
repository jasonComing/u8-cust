SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_SOSPs](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SOSP] [varchar](50) NOT NULL,
	[Class] [varchar](50) NULL,
	[ClassName] [varchar](50) NULL,
	[ClassType] [varchar](50) NULL,
	[Proportion] [decimal](18, 4) NULL,
	[Qty] [int] NULL,
 CONSTRAINT [PK_t_SOSPs] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


