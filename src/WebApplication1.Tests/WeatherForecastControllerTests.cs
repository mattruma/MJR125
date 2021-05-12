using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using WebApplication1.Controllers;
using Xunit;

namespace WebApplication1.Tests
{
    public class WeatherForecastControllerTests
    {
        [Fact]
        public void When_Get_Should_ReturnOK()
        {
            // Arrange
            var logger = new Mock<ILogger<WeatherForecastController>>();

            var controller = new WeatherForecastController(logger.Object);

            // Act

            var result = controller.Get();

            // Assert

            Assert.IsType<OkObjectResult>(result.Result);
        }
    }
}
