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

        //[Fact]
        //public void Given_Browser_When_Get_Should_ReturnOK()
        //{
        //    var options = new ChromeOptions();

        //    //options.AddArgument("--headless");

        //    options.AddArgument("--window-size=1920,1080");

        //    using (var driver = new ChromeDriver(".", options))
        //    {
        //        driver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(5);

        //        driver.Navigate().GoToUrl("https://localhost:44387/WeatherForecast");
        //    }
        //}
    }
}
